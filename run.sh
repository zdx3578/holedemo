#!/usr/bin/env bash
set -e
echo "[0] Prepare bias & recall"
cat > popper/bias.pl <<'EOF'
%%%%%%%%%%%%  Predicate catalogue  %%%%%%%%%%%%

% head predicate
%%%%%%%%%%%%  搜索空间  %%%%%%%%%%%%

head_pred(transform,2).            % transform(+Obj,+Color)

body_pred(color,2).                % color(+Obj,+Color)
body_pred(holes,2).                % holes(+Obj,+Int)
body_pred(has_hole,1).             % has_hole(+Obj)
body_pred(target_color,1).         % <— 新增一元常量谓词

%%%%%%%%%%%%  类型  %%%%%%%%%%%%

type(obj).     type(color).     type(int).

type(transform,(obj,color)).
type(color,    (obj,color)).
type(holes,    (obj,int)).
type(has_hole, (obj,)).
type(target_color,(color,)).      % <— 类型只有一个 color

constant(4,color).

%%%%%%%%%%%%  限制  %%%%%%%%%%%%

max_body(2).   max_vars(3).   max_clauses(1).
non_datalog.
EOF

cat > popper/recall.pl <<'EOF'
recall(transform/2,1,1).
EOF
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASE_DIR"
echo "[1] Extract objects"
for f in train/*.json; do
    python3 scripts/01_extract_objects.py "$f" > "tmp_bk_$(basename $f .json).pl"
done
echo "[2] Build bk.pl"
cat tmp_bk_*.pl > popper/bk.pl
echo "target_color(4)." >> popper/bk.pl

echo "[3] Emit examples"
python3 scripts/04_emit_examples.py train/*.json popper/exs.pl
echo "[4] Run popper"
(python3 Poppermain/popper.py --debug ./popper/  | tee popper/popper_stdout.log    )
echo "[4] Run popper -- grep solution"
# (grep -A3 '^********* SOLUTION *********' popper/popper_stdout.log   | grep -E '^transform' > popper/program.pl)
echo "[5] Apply rule to test"
RULE=popper/program.pl
if [ -f "$RULE" ]; then
    python3 scripts/apply_rules.py test/test.json "$RULE"
else
    echo "No program found"
fi
