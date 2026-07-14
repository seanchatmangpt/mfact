#!/usr/bin/env python3
"""
sim_qasm.py

A CLI tool to simulate the execution of a compiled OpenQASM 3.0 file.
"""

import argparse
import json
import re
import sys

def parse_instruction(line):
    line = line.strip()
    if '//' in line:
        line = line.split('//')[0].strip()
    if not line:
        return None, []
    if line.endswith(';'):
        line = line[:-1].strip()
        
    if '(' in line and line.endswith(')'):
        gate_name, args_str = line.split('(', 1)
        args_str = args_str[:-1]
        args = [a.strip() for a in args_str.split(',')]
        return gate_name.strip(), args
        
    parts = line.split(maxsplit=1)
    if not parts:
        return None, []
    gate_name = parts[0]
    if len(parts) == 1:
        return gate_name, []
    
    arg_part = parts[1]
    if ',' in arg_part:
        args = [a.strip() for a in arg_part.split(',')]
    else:
        args = [a.strip() for a in arg_part.split()]
    return gate_name, args

def extract_qubits(qasm_content):
    # Match qubit[N] name;
    qubit_arr_pattern = re.compile(r'qubit\s*\[\s*(\d+)\s*\]\s*(\w+)\s*;')
    # Match qubit name;
    qubit_single_pattern = re.compile(r'qubit\s+(\w+)\s*;')
    # OpenQASM 2.0 style qreg name[N];
    qreg_pattern = re.compile(r'qreg\s+(\w+)\s*\[\s*(\d+)\s*\]\s*;')
    
    qubits = set()
    
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
            if size == 1:
                qubits.add(name)
            else:
                for i in range(size):
                    qubits.add(f"{name}[{i}]")
            continue
            
        m_single = qubit_single_pattern.search(line)
        if m_single:
            name = m_single.group(1)
            qubits.add(name)
            continue
            
        m_qreg = qreg_pattern.search(line)
        if m_qreg:
            size = int(m_qreg.group(2))
            name = m_qreg.group(1)
            if size == 1:
                qubits.add(name)
            else:
                for i in range(size):
                    qubits.add(f"{name}[{i}]")
            continue
            
    return qubits

def get_qubit_for_place(place, declared_qubits):
    if place in declared_qubits:
        return place
    q_name = f"q_{place}"
    if q_name in declared_qubits:
        return q_name
    for q in declared_qubits:
        if q.endswith(f"_{place}"):
            return q
    return None

def get_place_from_qubit(qubit):
    if qubit.startswith("q_"):
        return qubit[2:]
    return qubit

def main():
    parser = argparse.ArgumentParser(description="Simulate compiled OpenQASM 3.0 circuit.")
    parser.add_argument('--circuit', type=str, required=True, help='Path to OpenQASM 3.0 file')
    parser.add_argument('--initial-marking', type=str, required=True, help='Comma-separated p:v pairs (e.g. p1:1,p2:0)')
    parser.add_argument('--fire', type=str, required=True, help='Transition to fire')
    parser.add_argument('--net', type=str, help='Path to Petri net JSON file (optional)')
    
    args = parser.parse_args()
    
    # Parse initial marking
    initial_marking = {}
    for pair in args.initial_marking.split(','):
        if not pair.strip():
            continue
        p, v = pair.split(':')
        initial_marking[p.strip()] = int(v.strip())
        
    try:
        with open(args.circuit) as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading circuit file: {e}")
        sys.exit(1)
        
    declared_qubits = extract_qubits(content)
    
    # Parse gates from circuit
    gates = []
    for line in content.splitlines():
        line = line.strip()
        if not line or line.startswith("OPENQASM") or line.startswith("include") or line.startswith("qubit") or line.startswith("qreg"):
            continue
        gate_name, gate_args = parse_instruction(line)
        if gate_name and gate_name in ["x", "cx", "mcx"]:
            gates.append((gate_name, gate_args))
            
    # Find ancilla for fired transition
    ancilla_qubit = None
    for q in declared_qubits:
        if q == f"ancilla_{args.fire}" or q.endswith(f"_{args.fire}"):
            ancilla_qubit = q
            break
            
    if not ancilla_qubit:
        print(f"Warning: Could not find ancilla qubit for transition '{args.fire}'. Running all gates.")
        filtered_gates = gates
    else:
        # Filter gates that reference the transition's ancilla
        filtered_gates = [g for g in gates if ancilla_qubit in g[1]]
        
    # Map places to qubits and initialize state
    state = {q: 0 for q in declared_qubits}
    place_to_qubit = {}
    for place, val in initial_marking.items():
        q = get_qubit_for_place(place, declared_qubits)
        if q:
            place_to_qubit[place] = q
            state[q] = val
        else:
            print(f"Warning: Qubit for place '{place}' not declared in circuit.")
            
    # For any place in declared_qubits not in initial_marking, initialize to 0
    place_qubits = {q for q in declared_qubits if q.startswith("q_")}
    for q in place_qubits:
        place_name = get_place_from_qubit(q)
        if place_name not in initial_marking:
            initial_marking[place_name] = 0
            place_to_qubit[place_name] = q
            
    # Compute expected marking
    expected_marking = initial_marking.copy()
    
    # If Petri Net is provided, compute transition firing exactly
    enabled = False
    if args.net:
        try:
            with open(args.net) as f:
                net_data = json.load(f)
            # Find pre/post for transition
            pre = {}
            post = {}
            if "pre" in net_data and args.fire in net_data["pre"]:
                pre = net_data["pre"][args.fire]
            if "post" in net_data and args.fire in net_data["post"]:
                post = net_data["post"][args.fire]
                
            enabled = all(initial_marking.get(p, 0) >= w for p, w in pre.items())
            if enabled:
                for p, w in pre.items():
                    expected_marking[p] = expected_marking.get(p, 0) - w
                for p, w in post.items():
                    expected_marking[p] = expected_marking.get(p, 0) + w
        except Exception as e:
            print(f"Warning: Could not compute expected marking from net JSON: {e}")
            args.net = None # Fallback to static analysis
            
    if not args.net:
        # Infer pre/post from gates referencing the ancilla
        pre_places = set()
        cx_targets = []
        for gate_name, gate_args in filtered_gates:
            if gate_name == "mcx" and gate_args[-1] == ancilla_qubit:
                pre_places.update(gate_args[:-1])
            elif gate_name == "cx" and gate_args[0] == ancilla_qubit:
                cx_targets.append(gate_args[1])
                
        # Transition is enabled if all pre-places are 1
        enabled = len(pre_places) > 0 and all(state.get(p, 0) == 1 for p in pre_places)
        if enabled:
            for q in place_qubits:
                p_name = get_place_from_qubit(q)
                is_pre = q in pre_places
                count = cx_targets.count(q)
                is_post = (count - (1 if is_pre else 0)) > 0
                
                delta = 0
                if is_pre:
                    delta -= 1
                if is_post:
                    delta += 1
                expected_marking[p_name] = expected_marking.get(p_name, 0) + delta

    # Run simulation
    print(f"Simulating transition '{args.fire}' firing...")
    print(f"Initial marking: {initial_marking}")
    print(f"Transition enabled: {enabled}")
    
    for gate_name, gate_args in filtered_gates:
        # Simulate
        if gate_name == "x":
            target = gate_args[0]
            state[target] = 1 - state[target]
        elif gate_name == "cx":
            ctrl, target = gate_args[0], gate_args[1]
            if state[ctrl] == 1:
                state[target] = 1 - state[target]
        elif gate_name == "mcx":
            ctrls = gate_args[:-1]
            target = gate_args[-1]
            if all(state[c] == 1 for c in ctrls):
                state[target] = 1 - state[target]

    # Measure final place markings
    final_marking = {}
    for p, q in place_to_qubit.items():
        final_marking[p] = state[q]
        
    print(f"Simulation final marking: {final_marking}")
    print(f"Expected final marking:   {expected_marking}")
    
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
