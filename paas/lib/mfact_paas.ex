defmodule MfactPaaS do
  @moduledoc """
  Off-core certification control plane for mfact.

  This service does not create mathematical standing and has no BRCE authority.
  It records a bounded certification request, writes a pre-actuation intent,
  invokes an allow-listed `just` recipe, persists the execution receipt, and
  snapshots the resulting standing evidence when the recipe succeeds.
  """

  alias MfactPaaS.Generated.Resources

  def certify(%{
        recipe: recipe,
        repo_root: repo_root,
        base_sha: base_sha,
        subject_sha: subject_sha
      }) do
    Reactor.run(
      MfactPaaS.CertificationReactor,
      %{
        recipe: recipe,
        repo_root: repo_root,
        base_sha: base_sha,
        subject_sha: subject_sha
      },
      %{},
      async?: false
    )
  end

  def export_r2rml(actor \\ nil) do
    Reactor.run(
      AshR2RML.Reactor.Pipeline,
      %{
        resources: Resources.all(),
        actor: actor,
        observations: [],
        metadata: %{system: "mfact-paas", authority: "projection-only"}
      },
      %{},
      async?: false
    )
  end
end

defmodule MfactPaaS.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    Supervisor.start_link([MfactPaaS.Repo], strategy: :one_for_one, name: MfactPaaS.Supervisor)
  end
end

defmodule MfactPaaS.Repo do
  @moduledoc false
  use AshPostgres.Repo, otp_app: :mfact_paas
end

defmodule MfactPaaS.Domain do
  @moduledoc false
  use Ash.Domain

  resources do
    resource MfactPaaS.Generated.CertificationRequest
    resource MfactPaaS.Generated.Receipt
    resource MfactPaaS.Generated.StandingRecord
  end
end

defmodule MfactPaaS.Refusal do
  @moduledoc false
  defexception [:code, :message, details: %{}]
end

defmodule MfactPaaS.Steps.ExecuteJust do
  @moduledoc false
  use Reactor.Step

  alias MfactPaaS.Refusal

  @allowed_recipes ~w(status doctor regen-check build audit test check certify quadrature fixtures)
  @admitted_remotes MapSet.new([
                      "https://github.com/seanchatmangpt/mfact",
                      "https://github.com/seanchatmangpt/mfact.git",
                      "git@github.com:seanchatmangpt/mfact.git"
                    ])

  @impl Reactor.Step
  def run(%{recipe: recipe, repo_root: repo_root, request: request}, _context, _options) do
    with :ok <- admitted_recipe(recipe),
         {:ok, git} <- executable("git"),
         :ok <- admitted_root(repo_root, request.base_sha, request.subject_sha, git),
         {:ok, just} <- executable("just") do
      execute_receipted(just, recipe, repo_root, request)
    end
  end

  defp admitted_recipe(recipe) when recipe in @allowed_recipes, do: :ok

  defp admitted_recipe(recipe) do
    {:error,
     %Refusal{
       code: "REFUSED_RECIPE_NOT_ALLOWED",
       message: "recipe is outside the mfact PaaS certification allow-list",
       details: %{recipe: recipe, allowed: @allowed_recipes}
     }}
  end

  defp admitted_root(repo_root, base_sha, subject_sha, git) do
    markers = [
      "AGENTS.md",
      "justfile",
      "ggen.toml",
      "mfact/lakefile.toml"
    ]

    with true <- Enum.all?(markers, &File.regular?(Path.join(repo_root, &1))),
         {head, 0} <- System.cmd(git, ["rev-parse", "HEAD"], cd: repo_root, stderr_to_stdout: true),
         true <- String.trim(head) == subject_sha,
         {_output, 0} <-
           System.cmd(git, ["merge-base", "--is-ancestor", base_sha, subject_sha],
             cd: repo_root,
             stderr_to_stdout: true
           ),
         {remote, 0} <-
           System.cmd(git, ["remote", "get-url", "origin"],
             cd: repo_root,
             stderr_to_stdout: true
           ),
         true <- MapSet.member?(@admitted_remotes, String.trim(remote)),
         {_output, 0} <-
           System.cmd(git, ["diff", "--quiet", "--ignore-submodules", "HEAD", "--"],
             cd: repo_root,
             stderr_to_stdout: true
           ) do
      :ok
    else
      false ->
        {:error,
         %Refusal{
           code: "REFUSED_SUBJECT_IDENTITY",
           message: "checkout identity does not match the admitted mfact subject",
           details: %{repo_root: repo_root, base_sha: base_sha, subject_sha: subject_sha}
         }}

      {output, exit_code} ->
        {:error,
         %Refusal{
           code: "REFUSED_SUBJECT_IDENTITY",
           message: "git could not establish the admitted mfact subject identity",
           details: %{
             repo_root: repo_root,
             base_sha: base_sha,
             subject_sha: subject_sha,
             exit_code: exit_code,
             output: output
           }
         }}
    end
  end

  defp executable(name) do
    case System.find_executable(name) do
      nil ->
        {:error,
         %Refusal{
           code: "REFUSED_TOOLCHAIN_MISSING",
           message: "required executable is not available",
           details: %{executable: name}
         }}

      path ->
        {:ok, path}
    end
  end

  defp execute_receipted(just, recipe, repo_root, request) do
    receipt_dir = Path.join(repo_root, "paas/var/receipts")
    File.mkdir_p!(receipt_dir)

    run_id = request.id |> to_string()
    intent_path = Path.join(receipt_dir, "#{run_id}.intent.json")
    receipt_path = Path.join(receipt_dir, "#{run_id}.json")
    started_at = DateTime.utc_now()

    intent = %{
      schema: "mfact.paas.intent.v1",
      request_id: run_id,
      recipe: recipe,
      base_sha: request.base_sha,
      subject_sha: request.subject_sha,
      started_at: DateTime.to_iso8601(started_at),
      phase: "PREPARED"
    }

    atomic_json!(intent_path, intent)

    {output, exit_code} =
      try do
        System.cmd(just, [recipe], cd: repo_root, stderr_to_stdout: true)
      rescue
        error ->
          {Exception.format(:error, error, __STACKTRACE__), 127}
      catch
        kind, reason ->
          {Exception.format(kind, reason, __STACKTRACE__), 127}
      end

    ended_at = DateTime.utc_now()
    stdout_sha256 = :crypto.hash(:sha256, output) |> Base.encode16(case: :lower)

    receipt = %{
      schema: "mfact.paas.receipt.v1",
      request_id: run_id,
      recipe: recipe,
      base_sha: request.base_sha,
      subject_sha: request.subject_sha,
      exit_code: exit_code,
      stdout_sha256: stdout_sha256,
      started_at: DateTime.to_iso8601(started_at),
      ended_at: DateTime.to_iso8601(ended_at),
      intent_path: Path.relative_to(intent_path, repo_root),
      receipt_path: Path.relative_to(receipt_path, repo_root)
    }

    atomic_json!(receipt_path, receipt)

    {:ok,
     %{
       exit_code: exit_code,
       output: output,
       stdout_sha256: stdout_sha256,
       started_at: started_at,
       ended_at: ended_at,
       receipt_path: Path.relative_to(receipt_path, repo_root)
     }}
  end

  defp atomic_json!(path, value) do
    tmp = path <> ".tmp-" <> Integer.to_string(System.unique_integer([:positive]))
    File.write!(tmp, Jason.encode_to_iodata!(value, pretty: true))
    File.rename!(tmp, path)
  end
end

defmodule MfactPaaS.CertificationReactor do
  @moduledoc false
  use Reactor, extensions: [Ash.Reactor]

  alias MfactPaaS.Generated.{CertificationRequest, Receipt, StandingRecord}
  alias MfactPaaS.Refusal

  input :recipe
  input :repo_root
  input :base_sha
  input :subject_sha

  ash_step :record_request do
    argument :recipe, input(:recipe)
    argument :base_sha, input(:base_sha)
    argument :subject_sha, input(:subject_sha)

    run fn %{recipe: recipe, base_sha: base_sha, subject_sha: subject_sha}, _ctx ->
      Ash.create(CertificationRequest, %{
        recipe: recipe,
        base_sha: base_sha,
        subject_sha: subject_sha,
        status: "PREPARED",
        requested_at: DateTime.utc_now()
      })
    end
  end

  step :execute_just, MfactPaaS.Steps.ExecuteJust do
    argument :recipe, input(:recipe)
    argument :repo_root, input(:repo_root)
    argument :request, result(:record_request)
    max_retries 0
  end

  ash_step :record_receipt do
    argument :request, result(:record_request)
    argument :execution, result(:execute_just)

    run fn %{request: request, execution: execution}, _ctx ->
      Ash.create(Receipt, %{
        request_id: request.id,
        exit_code: execution.exit_code,
        stdout_sha256: execution.stdout_sha256,
        receipt_path: execution.receipt_path,
        started_at: execution.started_at,
        ended_at: execution.ended_at
      })
    end
  end

  ash_step :snapshot_standing do
    argument :repo_root, input(:repo_root)
    argument :receipt, result(:record_receipt)
    argument :execution, result(:execute_just)

    run fn %{repo_root: repo_root, receipt: receipt, execution: execution}, _ctx ->
      if execution.exit_code == 0 do
        standing_path = Path.join(repo_root, "release/standing.env")

        case File.read(standing_path) do
          {:ok, body} ->
            certified_release =
              body
              |> String.split("\n")
              |> Enum.find_value(fn line ->
                case String.split(line, "=", parts: 2) do
                  ["CERTIFIED_RELEASE", value] -> value
                  _ -> nil
                end
              end)

            if is_nil(certified_release) do
              {:error,
               %Refusal{
                 code: "REFUSED_STANDING_INCOMPLETE",
                 message: "standing evidence is missing CERTIFIED_RELEASE",
                 details: %{path: standing_path}
               }}
            else
              sha256 = :crypto.hash(:sha256, body) |> Base.encode16(case: :lower)

              Ash.create(StandingRecord, %{
                receipt_id: receipt.id,
                certified_release: certified_release,
                standing_sha256: sha256,
                source_path: "release/standing.env",
                captured_at: DateTime.utc_now()
              })
            end

          {:error, reason} ->
            {:error,
             %Refusal{
               code: "REFUSED_STANDING_UNREADABLE",
               message: "successful recipe did not leave readable standing evidence",
               details: %{path: standing_path, reason: inspect(reason)}
             }}
        end
      else
        {:ok, nil}
      end
    end
  end

  ash_step :adjudicate do
    argument :receipt, result(:record_receipt)
    argument :standing, result(:snapshot_standing)
    argument :execution, result(:execute_just)

    run fn %{receipt: receipt, standing: standing, execution: execution}, _ctx ->
      if execution.exit_code == 0 do
        {:ok, %{receipt: receipt, standing: standing}}
      else
        {:error,
         %Refusal{
           code: "REFUSED_RECIPE_FAILED",
           message: "mfact certification recipe returned a non-zero exit status",
           details: %{
             exit_code: execution.exit_code,
             receipt_id: receipt.id,
             receipt_path: receipt.receipt_path
           }
         }}
      end
    end
  end

  return :adjudicate
end
