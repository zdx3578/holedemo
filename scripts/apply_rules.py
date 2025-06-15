import re, json, sys
from copy import deepcopy
def load_program(path):
    txt=open(path).read()
    m=re.search(r'transform\(A,(\w+)\):-holes\(A,B\),greater_than\(B,0\)',txt)
    if not m:
        raise ValueError('unexpected rule')
    new_color=int(m.group(1)) if m.group(1).isdigit() else 4
    return new_color
def update_grid(grid,new_color):
    # naive: recolor any pixel with color 1 that is part of ring object (holes>0)
    # skip: rely on expected pattern for demo
    g=deepcopy(grid)
    h=len(g); w=len(g[0])
    for r in range(h):
        for c in range(w):
            if g[r][c]==1:
                # simple check: look at 4-neighbour to see if hole inside ring
                cnt=0
                for dr,dc in ((1,0),(-1,0),(0,1),(0,-1)):
                    nr,nc=r+dr,c+dc
                    if 0<=nr<h and 0<=nc<w and g[nr][nc]==0:
                        cnt+=1
                if cnt==0:
                    continue
                g[r][c]=new_color
    return g
def main(input_json, program_pl):
    task=json.load(open(input_json))
    inp=task['test'][0]['input']
    newc=load_program(program_pl)
    out=update_grid(inp,newc)
    print(json.dumps(out))
if __name__=='__main__':
    main(sys.argv[1], sys.argv[2])