import Lean
import ProofWidgets
import ProcInt.Petri.Net

open Lean ProofWidgets
open ProcInt

/-!
# Interactive Visual Debugging with ProofWidgets4

This module sets up HTML/React SVGs for visually debugging
process geometries (e.g., Petri nets, Workflow nets) directly
inside the Lean Infoview.
-/

namespace ProcInt.Advanced.Visual

/--
A simple React component to render a Petri Net visually.
We use ProofWidgets to define the HTML representation.
-/
@[widget_module] def PetriNetVisualizer : Component Unit where
  javascript := "
    import * as React from 'react';
    export default function PetriNetVisualizer(props) {
      return React.createElement('div', { style: { padding: '10px', border: '1px solid #ccc' } },
        React.createElement('h3', null, 'Process Geometry Visualizer'),
        React.createElement('svg', { width: 300, height: 100 },
          // A sample place (circle)
          React.createElement('circle', { cx: 50, cy: 50, r: 20, stroke: 'black', strokeWidth: 2, fill: 'white' }),
          // A token
          React.createElement('circle', { cx: 50, cy: 50, r: 5, fill: 'black' }),
          // An arc
          React.createElement('line', { x1: 70, y1: 50, x2: 130, y2: 50, stroke: 'black', strokeWidth: 2, markerEnd: 'url(#arrow)' }),
          // A transition (rect)
          React.createElement('rect', { x: 130, y: 30, width: 20, height: 40, stroke: 'black', strokeWidth: 2, fill: 'white' })
        )
      );
    }
  "

/-
A UserWidget definition that can be attached to any Lean state
where we are evaluating or proving things about a Petri Net.
-/
#eval 1 -- Just a placeholder to ensure it typechecks (UserWidget definition uses more complex setup)

open Server in
@[server_rpc_method]
def getPetriNetHtml (args : String) : RequestM (RequestTask Html) :=
  RequestM.asTask do
    return Html.ofComponent PetriNetVisualizer () #[]

end ProcInt.Advanced.Visual
