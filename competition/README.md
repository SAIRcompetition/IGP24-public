# IGP24

IGP24 is the public SAIR competition package for the inverse Galois problem
in degree 24 over `Q`.

Start with:

```text
rules/overview.md
rules/evaluation.md
```

For this competition package, new `(24Tt, r)` pairs outside
`baseline/lmfdb_baseline.csv` are scoreable.  Baseline pairs can also score
when a participant finds a strict exact-`nfdisc` improvement over the baseline
threshold `D_base`; mixed discriminants do not unlock baseline pairs.

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

Verification uses [Magma](https://magma.maths.usyd.edu.au/magma/) through the
self-contained harness in `competition/tools/magma/`; it must be available on
the command line as `magma`.
