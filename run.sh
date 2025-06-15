#!/usr/bin/env bash
set -e
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
python3 scripts/apply_rules.py test/test.json "$RULE"