defmodule MfactPaaSTest do
  use ExUnit.Case, async: false

  alias MfactPaaS.Generated.Resources
  alias MfactPaaS.Refusal
  alias MfactPaaS.Steps.ExecuteJust

  @repo_root Path.expand("../..", __DIR__)

  test "ggen projected the admitted semantic resource set" do
    assert Resources.all() == [
             MfactPaaS.Generated.CertificationRequest,
             MfactPaaS.Generated.Receipt,
             MfactPaaS.Generated.StandingRecord
           ]
  end

  test "AshR2RML exports the same resources as R2RML" do
    assert {:ok, turtle} = MfactPaaS.export_r2rml()
    assert is_binary(turtle)
    assert turtle =~ "TriplesMap"
    assert turtle =~ "https://mfact.dev/paas#CertificationRequest"
    assert turtle =~ "https://mfact.dev/paas#Receipt"
    assert turtle =~ "https://mfact.dev/paas#StandingRecord"
  end

  test "Reactor executes a receipted, allow-listed mfact recipe and snapshots standing" do
    base_sha = System.fetch_env!("MFACT_PAAS_BASE_SHA")
    subject_sha = System.fetch_env!("MFACT_PAAS_SUBJECT_SHA")

    assert {:ok, %{receipt: receipt, standing: standing}} =
             MfactPaaS.certify(%{
               recipe: "status",
               repo_root: @repo_root,
               base_sha: base_sha,
               subject_sha: subject_sha
             })

    assert receipt.exit_code == 0
    assert File.regular?(Path.join(@repo_root, receipt.receipt_path))
    assert standing.certified_release == "PASS"
    assert standing.standing_sha256 =~ ~r/^[0-9a-f]{64}$/
    assert standing.source_path == "release/standing.env"
  end

  test "unadmitted recipes are typed refusals before shell execution" do
    fake_request = %{
      id: Ash.UUID.generate(),
      base_sha: "test-base",
      subject_sha: "test-subject"
    }

    assert {:error, %Refusal{code: "REFUSED_RECIPE_NOT_ALLOWED"}} =
             ExecuteJust.run(
               %{recipe: "release", repo_root: @repo_root, request: fake_request},
               %{},
               []
             )
  end
end
