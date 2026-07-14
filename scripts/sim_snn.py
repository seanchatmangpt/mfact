#!/usr/bin/env python3
"""
sim_snn.py

A CLI tool to simulate SNN network step execution.
"""

import argparse
import json
import sys

def infer_snn_neurons(neurons, synapses):
    neuron_ids = {n["id"] for n in neurons}
    enablement_neurons = set()
    place_neurons = set()
    transition_neurons = set()
    
    # Classify by ID naming first
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
                    
    # Fallback to topology
    if not place_neurons or not transition_neurons:
        outgoing = {nid: [] for nid in neuron_ids}
        incoming = {nid: [] for nid in neuron_ids}
        for syn in synapses:
            src = syn["source"]
            tgt = syn["target"]
            if src in neuron_ids and tgt in neuron_ids:
                outgoing[src].append(tgt)
                incoming[tgt].append(src)
        
        for nid in neuron_ids:
            if len(incoming[nid]) > 0 and len(outgoing[nid]) > 0:
                is_enablement = False
                for src_node in incoming[nid]:
                    for tgt_node in outgoing[nid]:
                        is_enablement = True
                if is_enablement:
                    enablement_neurons.add(nid)
        
        for en in enablement_neurons:
            place_neurons.update(incoming[en])
            transition_neurons.update(outgoing[en])
            
    return place_neurons, transition_neurons, enablement_neurons

def main():
    parser = argparse.ArgumentParser(description="Simulate SNN execution step-by-step.")
    parser.add_argument('--network', type=str, required=True, help='Path to SNN JSON file')
    parser.add_argument('--initial-marking', type=str, required=True, help='Comma-separated p:v pairs (e.g. p1:1,p2:0)')
    parser.add_argument('--fire', type=str, required=True, help='Transition to fire')
    parser.add_argument('--net', type=str, help='Path to Petri net JSON file (optional)')
    parser.add_argument('--cycles', type=int, default=2, help='Number of clock cycles to simulate (default: 2)')
    
    args = parser.parse_args()
    
    # Parse initial marking
    initial_marking = {}
    for pair in args.initial_marking.split(','):
        if not pair.strip():
            continue
        p, v = pair.split(':')
        initial_marking[p.strip()] = int(v.strip())
        
    try:
        with open(args.network) as f:
            snn_data = json.load(f)
    except Exception as e:
        print(f"Error reading SNN file: {e}")
        sys.exit(1)
        
    if "neurons" not in snn_data or "synapses" not in snn_data:
        print("Error: SNN JSON must contain 'neurons' and 'synapses'.")
        sys.exit(1)
        
    neurons = snn_data["neurons"]
    synapses = snn_data["synapses"]
    
    # Build thresholds lookup
    thresholds = {n["id"]: n.get("threshold", 1) for n in neurons}
    
    # Classify neurons
    place_neurons, transition_neurons, enablement_neurons = infer_snn_neurons(neurons, synapses)
    
    print(f"Classified SNN: {len(place_neurons)} Places, {len(transition_neurons)} Transitions, {len(enablement_neurons)} Enablement Neurons.")
    
    # Initialize potentials
    v_place = {}
    v_enable = {}
    v_trans = {}
    
    # helper to find neuron ID from place name
    def find_nid(name, candidates):
        if name in candidates:
            return name
        n_name = f"n_{name}"
        if n_name in candidates:
            return n_name
        for c in candidates:
            if c.endswith(f"_{name}"):
                return c
        return None
        
    # Initialize place potentials
    for pn in place_neurons:
        p_name = pn[2:] if pn.startswith("n_") else pn
        v_place[pn] = initial_marking.get(p_name, 0)
        
    # Initialize enablement potentials to match places initially (per SnnRefinement)
    for en in enablement_neurons:
        # find matching place
        matching_p = None
        for pn in place_neurons:
            p_prefix = pn + "_"
            if en.startswith(p_prefix):
                matching_p = pn
                break
        if matching_p:
            v_enable[en] = v_place[matching_p]
        else:
            # try to parse place name from start of body
            v_enable[en] = 0
            
    # Initialize transition potentials
    for tn in transition_neurons:
        v_trans[tn] = 0
        
    # Identify the target transition neuron
    target_tn = find_nid(args.fire, transition_neurons)
    if not target_tn:
        print(f"Error: Transition '{args.fire}' not found in SNN transition neurons.")
        sys.exit(1)
        
    # Inject current/spike for the fired transition
    # We do this by setting v_enable of all enablement neurons feeding into target_tn to their thresholds
    target_ens = [syn["source"] for syn in synapses if syn["target"] == target_tn and syn["source"] in enablement_neurons]
    print(f"Injecting current into enablement neurons for '{args.fire}': {target_ens}")
    for en in target_ens:
        v_enable[en] = thresholds.get(en, 1)
        
    # Compute expected marking if Petri Net is provided
    expected_marking = initial_marking.copy()
    if args.net:
        try:
            with open(args.net) as f:
                net_data = json.load(f)
            pre = net_data.get("pre", {}).get(args.fire, {})
            post = net_data.get("post", {}).get(args.fire, {})
            enabled = all(initial_marking.get(p, 0) >= w for p, w in pre.items())
            if enabled:
                for p, w in pre.items():
                    expected_marking[p] = expected_marking.get(p, 0) - w
                for p, w in post.items():
                    expected_marking[p] = expected_marking.get(p, 0) + w
        except Exception as e:
            print(f"Warning: Could not compute expected marking from net JSON: {e}")
            args.net = None
            
    if not args.net:
        # Infer preset and postset weights of args.fire from SNN synapses
        # Pre weight: threshold of the enablement neuron
        # Post weight: weight of trans_to_place_synapses
        pre = {}
        post = {}
        for en in target_ens:
            # en is n_p_t
            # find corresponding place
            matching_pn = None
            for pn in place_neurons:
                if en.startswith(pn + "_"):
                    matching_pn = pn
                    break
            if matching_pn:
                p_name = matching_pn[2:] if matching_pn.startswith("n_") else matching_pn
                pre[p_name] = thresholds.get(en, 1)
                
        # Find feedback synapses
        feedback_syns = [s for s in synapses if s["source"] == target_tn and s["target"] in place_neurons]
        for syn in feedback_syns:
            pn = syn["target"]
            p_name = pn[2:] if pn.startswith("n_") else pn
            weight = syn["weight"]
            # weight = post_weight - pre_weight => post_weight = weight + pre_weight
            pre_w = pre.get(p_name, 0)
            post_w = weight + pre_w
            if post_w > 0:
                post[p_name] = post_w
                
        # Compute expected marking
        enabled = all(initial_marking.get(p, 0) >= w for p, w in pre.items())
        if enabled:
            for p, w in pre.items():
                expected_marking[p] = expected_marking.get(p, 0) - w
            for p, w in post.items():
                expected_marking[p] = expected_marking.get(p, 0) + w

    # Simulate step-by-step
    print(f"Simulating SNN for {args.cycles} cycles...")
    for cycle in range(1, args.cycles + 1):
        # Step logic
        s_enable = {en: v_enable[en] >= thresholds.get(en, 1) for en in enablement_neurons}
        
        # Next transition potentials
        v_trans_next = {}
        s_trans = {}
        for tn in transition_neurons:
            incoming = [s for s in synapses if s["target"] == tn]
            acc = sum(1 for s in incoming if s_enable.get(s["source"], False))
            v_trans_next[tn] = acc
            s_trans[tn] = acc >= thresholds.get(tn, 1)
            
        # Next place potentials
        v_place_next = {}
        for pn in place_neurons:
            incoming = [s for s in synapses if s["target"] == pn]
            net_change = sum(s["weight"] for s in incoming if s_trans.get(s["source"], False))
            v_place_next[pn] = max(0, v_place[pn] + net_change)
            
        # Next enablement potentials
        v_enable_next = {}
        for en in enablement_neurons:
            incoming = [s for s in synapses if s["target"] == en]
            acc = sum(v_place[s["source"]] for s in incoming if s["source"] in place_neurons)
            v_enable_next[en] = acc
            
        # Update SNN state
        v_place = v_place_next
        v_enable = v_enable_next
        v_trans = v_trans_next
        
        print(f"Cycle {cycle}:")
        print(f"  v_place:  {v_place}")
        print(f"  v_enable: {v_enable}")
        print(f"  v_trans:  {v_trans}")

    # Read out place potentials as markings
    final_marking = {}
    for pn in place_neurons:
        p_name = pn[2:] if pn.startswith("n_") else pn
        final_marking[p_name] = v_place[pn]
        
    print(f"Final SNN place potentials: {final_marking}")
    print(f"Expected final markings:    {expected_marking}")
    
    matches = True
    for p in expected_marking:
        if final_marking.get(p, 0) != expected_marking[p]:
            matches = False
            break
            
    if matches:
        print("STATUS: SUCCESS")
        sys.exit(0)
    else:
        print("STATUS: FAILURE")
        sys.exit(1)

if __name__ == "__main__":
    main()
