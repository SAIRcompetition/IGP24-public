# IGP24

IGP24 is a draft SAIR competition package for the inverse Galois problem in
degree 24 over `Q`.

Start with:

```text
rules/overview.md
rules/evaluation.md
```

Public reference examples are in:

```text
../public package/materials/
```

They are not intended as scoreable competition submissions; the draft baseline
includes them so public examples cannot be resubmitted for leaderboard credit.

## Organizers

IGP24 is organized by (in alphabetical order by surname):

- John Jones
- Jen Paulhus
- David Roe
- Andrew Sutherland
- Terence Tao

## Submission Format

Contestants submit `submission.txt`, one polynomial per line:

```text
a_0,a_1,...,a_24
```

The coefficients are integers in ascending powers of `x`.

## Local Smoke Test

```bash
./competition/tools/submission verifier \
  competition/examples/sample_submission.txt \
  /tmp/igp24_verified.csv \
  2

python3 competition/tools/scoring reference \
  /tmp/igp24_verified.csv \
  --baseline competition/baseline/baseline_pairs.csv \
  --summary /tmp/igp24_summary.json \
  --novel-pairs /tmp/igp24_novel_pairs.csv
```

Magma must be available as `magma`.
