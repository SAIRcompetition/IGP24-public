# IGP24

IGP24 is a draft SAIR competition package for the inverse Galois problem in
degree 24 over `Q`.

Start with:

```text
rules/overview.md
rules/evaluation.md
```

Reference reference examples are in:

```text
../public package/materials/
```

They are research outputs and examples, not the scoring baseline.  For this
competition package, scoring excludes the `(24Tt, r)` pairs present in
`baseline/lmfdb_baseline.csv` unless the organizers explicitly freeze a
broader baseline before launch.

## Organizers

IGP24 is organized by (in alphabetical order by surname):

- John Jones
- Jen Paulhus
- David Roe
- Andrew Sutherland
- Terence Tao

## Submission Format

Contestants submit `submission.txt`, one monic degree 24 polynomial per line,
as 25 comma-separated integer coefficients in ascending powers of $x$, i.e.
$a_0, a_1, \ldots, a_{24}$:

```text
a_0,a_1,...,a_24
```

Each accepted coefficient line must have $a_0 \neq 0$ and $a_{24}=1$.

## Local Smoke Test

```bash
./competition/tools/submission verifier \
  competition/examples/sample_submission.txt \
  /tmp/igp24_verified.csv \
  2

python3 competition/tools/number_field_discriminant/discriminant calculator \
  /tmp/igp24_verified.csv \
  --output /tmp/igp24_discriminants.csv \
  --timeout 60 \
  --mixed-bound 100000

python3 competition/tools/scoring reference \
  /tmp/igp24_verified.csv \
  --discriminants /tmp/igp24_discriminants.csv \
  --baseline competition/baseline/lmfdb_baseline.csv \
  --summary /tmp/igp24_summary.json
```

Verification uses [Magma](https://magma.maths.usyd.edu.au/magma/), a
computational algebra system; it must be available on the command line as
`magma`.
