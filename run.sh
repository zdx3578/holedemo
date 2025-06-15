#!/usr/bin/env bash
set -e
echo "[0] Prepare bias & recall"
cat > popper/bias.pl <<'EOF'
%%%%%%%%%%%%  Predicate catalogue  %%%%%%%%%%%%

% head predicate
head_pred(transform,2).            % transform(+Obj,#Color)

% —— BK 谓词 ——
body_pred(color,2).                % color(+Obj,#Color)
body_pred(holes,2).                % holes(+Obj,#Int)
body_pred(has_hole,1).             % has_hole(+Obj)
body_pred(object,1).               % object(+Obj)

%%%%%%%%%%%%  Type system  %%%%%%%%%%%%

type(obj).
type(color).
type(int).

type(transform,(obj,color)).
type(color,    (obj,color)).
type(holes,    (obj,int)).
type(has_hole, (obj,)).
type(object,   (obj,)).

%%%%%%%%%%%%  Constants  %%%%%%%%%%%%

constant(color,4).                 % 黄色常量，Popper 才能绑定 4

%%%%%%%%%%%%  Search limits  %%%%%%%%%%%%

max_body(2).
max_vars(3).
max_clauses(1).
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
echo "[3] Emit examples"
python3 scripts/04_emit_examples.py train/*.json popper/exs.pl
echo "[4] Run popper"
(python3 Poppermain/popper.py --debug ./popper/ )
echo "[5] Apply rule to test"
RULE=popper/program.pl
if [ -f "$RULE" ]; then
    python3 scripts/apply_rules.py test/test.json "$RULE"
else
    echo "No program found"
fi
