import json, sys
from collections import deque
def flood(grid,start,target):
    h=len(grid); w=len(grid[0])
    q=deque([start]); comp=[]; seen={start}
    while q:
        r,c=q.popleft(); comp.append((r,c))
        for dr,dc in ((1,0),(-1,0),(0,1),(0,-1)):
            nr,nc=r+dr,c+dc
            if 0<=nr<h and 0<=nc<w and (nr,nc) not in seen and grid[nr][nc] in target:
                seen.add((nr,nc)); q.append((nr,nc))
    return comp
def bbox(comp):
    rs=[r for r,_ in comp]; cs=[c for _,c in comp]
    return min(rs),min(cs),max(rs),max(cs)
def count_holes(grid,comp):
    r0,c0,r1,c1=bbox(comp)
    h=r1-r0+1; w=c1-c0+1
    obj={(r-r0,c-c0) for r,c in comp}
    seen=[[False]*w for _ in range(h)]
    holes=0
    for r in range(h):
        for c in range(w):
            if (r,c) in obj or seen[r][c]: continue
            blob=flood([[0 if (rr,cc) not in obj else 1 for cc in range(w)] for rr in range(h)],(r,c),{0})
            edge=False
            for rr,cc in blob:
                if rr in (0,h-1) or cc in (0,w-1): edge=True
                seen[rr][cc]=True
            if not edge: holes+=1
    return holes
def extract(grid):
    h=len(grid); w=len(grid[0]); seen=[[False]*w for _ in range(h)]
    comps=[]
    for r in range(h):
        for c in range(w):
            if grid[r][c]!=0 and not seen[r][c]:
                comp=flood(grid,(r,c),{grid[r][c]})
                for rr,cc in comp: seen[rr][cc]=True
                comps.append(comp)
    facts=[]
    for i,comp in enumerate(comps,1):
        color=grid[comp[0][0]][comp[0][1]]
        holes=count_holes(grid,comp)
        facts.append((f"o{i}",color,holes))
    return facts
def to_prolog(facts,tid):
    lines=[]
    for oid,col,holes in facts:
        name=f"{oid}_{tid}"
        lines.append(f"object({name}).")
        lines.append(f"color({name},{col}).")
        lines.append(f"holes({name},{holes}).")
        if holes>0:
            lines.append(f"has_hole({name}).")
    return lines
if __name__=='__main__':
    f=sys.argv[1]; tid=f.split('/')[-1].split('.')[0]
    data=json.load(open(f))
    grid=data['train'][0]['input'] if 'train' in data else data['test'][0]['input']
    for l in to_prolog(extract(grid),tid):
        print(l)