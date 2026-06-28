# IGP24 Public Competition Package

IGP24 is SAIR's inverse Galois problem competition in degree 24 over
`Q`.  The goal is to find explicit monic integer polynomials of degree 24
whose Galois groups and signatures realize as many scoreable `(24Tt, r)`
pairs as possible.

## Co-organizers

IGP24 is co-organized by, in alphabetical order by surname:

- John Jones
- Jen Paulhus
- David Roe
- Andrew Sutherland
- Terence Tao

IGP24 is run in collaboration with the [LMFDB](https://www.lmfdb.org/).

## Background

The inverse Galois problem asks whether every finite group occurs as the
Galois group of a number field.  In this degree-specific competition, the
question becomes: for each transitive permutation group on 24 letters, can we
find an irreducible polynomial over `Q` whose Galois group realizes it?

Degree 24 is a large concrete frontier.  There are 25,000 transitive groups
of degree 24, labelled `24T1` through `24T25000`, and 165,836 possible
`(24Tt, r)` targets when signatures are included.

The frozen LMFDB-derived scoring baseline in this repository covers 286
distinct `24Tt` labels and 622 distinct `(24Tt, r)` pairs.  New pairs outside
this baseline are scoreable.  Baseline pairs can also score when a participant
finds a strict exact-`nfdisc` improvement over the baseline threshold
`D_base`.

## Repository Layout

```text
competition/                  public competition package
competition/rules/             overview and evaluation rules
competition/baseline/          target-space and LMFDB-derived baseline files
competition/examples/          sample submission
competition/tools/             verifier, discriminant, and scoring tools
```

## Start Here

- [Competition overview](competition/rules/overview.md)
- [Evaluation protocol](competition/rules/evaluation.md)
- [Baseline data](competition/baseline/README.md)

## Local Smoke Test

The local verifier requires [Magma](https://magma.maths.usyd.edu.au/magma/)
on the command line as `magma`.  Discriminant computation requires
[PARI/GP](https://pari.math.u-bordeaux.fr/) on the command line as `gp`.

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
