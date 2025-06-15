"""Emit examples.pl for Popper using LGG program to decide expected transform.
Very simplified: any object with holes>0 should be yellow (4).
"""
import sys, json
def main(task_files, out_examples):
    pos=[]
    neg=[]
    for tf in task_files:
        tid=tf.split('/')[-1].split('.')[0]
        facts= [l.strip() for l in open(f'tmp_bk_{tid}.pl')]
        # parse holes lines
        holes={}
        color={}
        for l in facts:
            if l.startswith('holes('):
                oid,val=l[6:].split(','); val=int(val[:-2]); holes[oid]=val
            if l.startswith('color('):
                oid,val=l[6:].split(','); val=int(val[:-2]); color[oid]=val
        for oid,h in holes.items():
            if h>0:
                pos.append(f'transform({oid},4).')
                if color[oid]!=4:
                    neg.append(f'transform({oid},{color[oid]}).')
            else:
                neg.append(f'transform({oid},4).')
    with open(out_examples,'w') as f:
        for p in pos:
            f.write('pos(' + p + ').\n')
        for n in neg:
            f.write('neg(' + n + ').\n')
if __name__=='__main__':
    main(sys.argv[1:-1], sys.argv[-1])