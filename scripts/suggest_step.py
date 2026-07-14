#!/usr/bin/env python3
import sys

def main():
    if len(sys.argv) < 2:
        print("decide")
        return

    goal = sys.argv[1]
    goal_lower = goal.lower()

    # Determine suggestion based on the goal string content
    if "lifecyclemarkingsum" in goal_lower or "brokernet" in goal_lower:
        # Broker net proof obligations often need omega or simp or decide
        if "step" in goal_lower:
            print("omega")
        else:
            print("simp")
    elif "2 + 2" in goal or "4 = 4" in goal or "2+2" in goal:
        print("decide")
    elif "rfl" in goal_lower:
        print("rfl")
    elif "omega" in goal_lower:
        print("omega")
    elif "=" in goal:
        # Default equality solver
        print("decide")
    else:
        print("simp")

if __name__ == "__main__":
    main()
