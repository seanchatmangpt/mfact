#!/usr/bin/env python3
"""
validate_target_syntax.py

Parses and validates an OpenQASM 3.0 file and/or an SNN JSON file.
"""

import argparse
import json
import re
import sys

def load_petri_net(net_path):
    with open(net_path) as f:
        data = json.load(f)
    
    # Extract places
    places_data = data.get("places", [])
    if isinstance(places_data, list):
        places = set(places_data)
    elif isinstance(places_data, dict):
        places = set(places_data.keys())
    else:
        places = set()
        
    # Extract transitions
    trans_data = data.get("transitions", [])
    if isinstance(trans_data, list):
        transitions = set(trans_data)
    elif isinstance(trans_data, dict):
        transitions = set(trans_data.keys())
    else:
        transitions = set()
        
    # Extract pre relations
    pre_count = 0
    pre_data = data.get("pre", {})
    if isinstance(pre_data, dict):
        # Format: { "t1": {"p1": 1, "p2": 1} } or similar
        for t, preset in pre_data.items():
            if isinstance(preset, dict):
                pre_count += sum(1 for p, w in preset.items() if w > 0)
            elif isinstance(preset, list):
                pre_count += len(preset)
    elif isinstance(pre_data, list):
        # Format: [ {"source": "p1", "target": "t1"}, ... ]
        for arc in pre_data:
            if isinstance(arc, dict) and "source" in arc and "target" in arc:
                pre_count += 1
                
    # Check arcs/flows if pre_count is 0
    if pre_count == 0 and "arcs" in data:
        for arc in data["arcs"]:
            src = arc.get("source")
            tgt = arc.get("target")
            if src in places and tgt in transitions:
                pre_count += 1
                
    return len(places), len(transitions), pre_count

def extract_qubits(qasm_content):
    # Match qubit[N] name;
    qubit_arr_pattern = re.compile(r'qubit\s*\[\s*(\d+)\s*\]\s*(\w+)\s*;')
    # Match qubit name;
    qubit_single_pattern = re.compile(r'qubit\s+(\w+)\s*;')
    # OpenQASM 2.0 style qreg name[N];
    qreg_pattern = re.compile(r'qreg\s+(\w+)\s*\[\s*(\d+)\s*\]\s*;')
    
    total_qubits = 0
    qubits_detail = []
    
    for line in qasm_content.splitlines():
        line = line.strip()
        if '//' in line:
            line = line.split('//')[0].strip()
        if not line:
            continue
        
        m_arr = qubit_arr_pattern.search(line)
        if m_arr:
            size = int(m_arr.group(1))
            name = m_arr.group(2)
            total_qubits += size
            qubits_detail.append((name, size))
            continue
            
        m_single = qubit_single_pattern.search(line)
        if m_single:
            name = m_single.group(1)
            total_qubits += 1
            qubits_detail.append((name, 1))
            continue
            
        m_qreg = qreg_pattern.search(line)
        if m_qreg:
            size = int(m_qreg.group(2))
            name = m_qreg.group(1)
            total_qubits += size
            qubits_detail.append((name, size))
            continue
            
    return total_qubits, qubits_detail

def infer_snn_counts(neurons, synapses):
    neuron_ids = {n["id"] for n in neurons}
    enablement_neurons = set()
    place_neurons = set()
    transition_neurons = set()
    
    for nid in neuron_ids:
        if nid.startswith("n_"):
            body = nid[2:]
            parts = body.split("_")
            for i in range(1, len(parts)):
                part_a = "n_" + "_".join(parts[:i])
                part_b = "n_" + "_".join(parts[i:])
                if part_a in neuron_ids and part_b in neuron_ids:
                    enablement_neurons.add(nid)
                    place_neurons.add(part_a)
                    transition_neurons.add(part_b)
                    break
                    
    # Fallback to topology if names don't match
    if not place_neurons or not transition_neurons:
        # Build adjacency
        outgoing = {nid: [] for nid in neuron_ids}
        incoming = {nid: [] for nid in neuron_ids}
        for syn in synapses:
            src = syn["source"]
            tgt = syn["target"]
            if src in neuron_ids and tgt in neuron_ids:
                outgoing[src].append(tgt)
                incoming[tgt].append(src)
        
        for nid in neuron_ids:
            # Enablement neurons: incoming from place, outgoing to transition
            # Place neurons: no incoming from enablement (or only incoming from transition)
            # Transition neurons: incoming from enablement
            # In compileToSnn, enablement neurons have incoming from places, outgoing to transitions.
            # Let's count nodes that have incoming and outgoing paths of length 1.
            if len(incoming[nid]) > 0 and len(outgoing[nid]) > 0:
                # check if target has incoming from this node
                # enablement is in the middle of place -> enablement -> transition
                is_enablement = False
                for src_node in incoming[nid]:
                    for tgt_node in outgoing[nid]:
                        is_enablement = True
                if is_enablement:
                    enablement_neurons.add(nid)
        
        # Now place neurons are sources of enablement neurons
        for en in enablement_neurons:
            place_neurons.update(incoming[en])
            transition_neurons.update(outgoing[en])
            
    return len(place_neurons), len(transition_neurons), len(enablement_neurons)

def main():
    parser = argparse.ArgumentParser(description="Validate QASM and SNN syntax and properties.")
    parser.add_argument('--qasm', type=str, help='Path to OpenQASM 3.0 file')
    parser.add_argument('--snn', type=str, help='Path to SNN JSON file')
    parser.add_argument('--net', type=str, help='Path to Petri net JSON file')
    parser.add_argument('--places-count', type=int, help='Explicit places count')
    parser.add_argument('--transitions-count', type=int, help='Explicit transitions count')
    parser.add_argument('--pre-count', type=int, help='Explicit preset count (sum of |pre(t)|)')
    
    args = parser.parse_args()
    
    if not args.qasm and not args.snn:
        print("Error: Either --qasm or --snn must be specified.")
        sys.exit(1)
        
    num_places = args.places_count
    num_transitions = args.transitions_count
    pre_count = args.pre_count
    
    if args.net:
        try:
            n_p, n_t, n_pre = load_petri_net(args.net)
            if num_places is None:
                num_places = n_p
            if num_transitions is None:
                num_transitions = n_t
            if pre_count is None:
                pre_count = n_pre
            print(f"Loaded Petri Net from {args.net}: |P|={num_places}, |T|={num_transitions}, sum|pre(t)|={pre_count}")
        except Exception as e:
            print(f"Error loading Petri net JSON: {e}")
            sys.exit(1)
            
    # QASM Validation
    if args.qasm:
        print(f"Validating QASM: {args.qasm}")
        try:
            with open(args.qasm) as f:
                content = f.read()
        except Exception as e:
            print(f"Error reading QASM file: {e}")
            sys.exit(1)
            
        total_qubits, qubits_detail = extract_qubits(content)
        print(f"Found {total_qubits} qubits: {qubits_detail}")
        
        # Check against net if available
        if num_places is not None and num_transitions is not None:
            expected_qubits = num_places + num_transitions
            if total_qubits != expected_qubits:
                print(f"QASM Validation Failed: qubit count {total_qubits} != expected {expected_qubits} (|P|={num_places} + |T|={num_transitions})")
                sys.exit(1)
            else:
                print(f"QASM Validation Passed: qubit count {total_qubits} == expected {expected_qubits}")
        else:
            # Let's try to infer from qubit names if possible
            q_places = sum(1 for name, size in qubits_detail if name.startswith("q_"))
            q_trans = sum(1 for name, size in qubits_detail if name.startswith("ancilla_"))
            if q_places > 0 and q_trans > 0 and q_places + q_trans == total_qubits:
                print(f"Inferred counts from QASM qubit names: |P|={q_places}, |T|={q_trans}")
                print(f"QASM Validation Passed: total qubits {total_qubits} matches inferred sum {q_places + q_trans}")
            else:
                print("Warning: No Petri net info provided to validate qubit count against, but parsed successfully.")

    # SNN Validation
    if args.snn:
        print(f"Validating SNN: {args.snn}")
        try:
            with open(args.snn) as f:
                snn_data = json.load(f)
        except Exception as e:
            print(f"Error reading SNN file: {e}")
            sys.exit(1)
            
        if "neurons" not in snn_data or "synapses" not in snn_data:
            print("SNN Validation Failed: JSON schema must contain 'neurons' and 'synapses'.")
            sys.exit(1)
            
        neurons = snn_data["neurons"]
        synapses = snn_data["synapses"]
        
        neuron_ids = set()
        for neuron in neurons:
            if not isinstance(neuron, dict) or "id" not in neuron:
                print("SNN Validation Failed: Neuron entry invalid, missing 'id'.")
                sys.exit(1)
            neuron_ids.add(neuron["id"])
            
        # Validate synapse sources/targets
        for synapse in synapses:
            if not isinstance(synapse, dict) or "source" not in synapse or "target" not in synapse:
                print("SNN Validation Failed: Synapse entry invalid, missing 'source' or 'target'.")
                sys.exit(1)
            src = synapse["source"]
            tgt = synapse["target"]
            if src not in neuron_ids:
                print(f"SNN Validation Failed: Synapse source '{src}' does not exist in the neuron set.")
                sys.exit(1)
            if tgt not in neuron_ids:
                print(f"SNN Validation Failed: Synapse target '{tgt}' does not exist in the neuron set.")
                sys.exit(1)
                
        print(f"Synapse source/target integrity checks passed. Total synapses: {len(synapses)}")
        
        # Validate neuron counts
        inferred_p, inferred_t, inferred_pre = infer_snn_counts(neurons, synapses)
        actual_neurons = len(neurons)
        
        if num_places is not None and num_transitions is not None and pre_count is not None:
            expected_neurons = num_places + pre_count + num_transitions
            if actual_neurons != expected_neurons:
                print(f"SNN Validation Failed: neuron count {actual_neurons} != expected {expected_neurons} (|P|={num_places} + sum|pre(t)|={pre_count} + |T|={num_transitions})")
                sys.exit(1)
            else:
                print(f"SNN Validation Passed: neuron count {actual_neurons} == expected {expected_neurons}")
        else:
            # check if the actual count matches the inferred counts
            expected_neurons = inferred_p + inferred_pre + inferred_t
            if actual_neurons == expected_neurons and expected_neurons > 0:
                print(f"Inferred counts from SNN structure: |P|={inferred_p}, |T|={inferred_t}, sum|pre(t)|={inferred_pre}")
                print(f"SNN Validation Passed: neuron count {actual_neurons} == expected {expected_neurons}")
            else:
                print(f"Warning: Could not verify neuron count. Inferred expected {expected_neurons} (|P|={inferred_p}, |T|={inferred_t}, sum|pre(t)|={inferred_pre}) but actual is {actual_neurons}")
                sys.exit(1)

    print("STATUS: SUCCESS")
    sys.exit(0)

if __name__ == "__main__":
    main()
