"""anti_unify λ list (S‑expr strings). For demo, just return first one."""
import json, sys, ast

def main():
    lambdas = [ast.literal_eval(line.strip()) for line in sys.stdin if line.strip()]
    # trivial LGG: return first (for demo)
    print(json.dumps(lambdas[0]))
if __name__=='__main__':
    main()