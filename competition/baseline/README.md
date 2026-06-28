# IGP24 Baseline

This directory holds the reference tables used by the IGP24 evaluator.

## `valid_pairs.csv`

The complete universe of group-theoretically possible degree-24 signatures
`(24Tt, r)` -- 165,836 rows. For every transitive group `G` of degree 24
(labels `24T1` through `24T25000`), `r` is the number of real roots of the
polynomial, i.e. the number of fixed points of complex conjugation. Complex
conjugation is an element of `G` of order dividing 2, so the possible values of
`r` for `G` are the fixed-point counts of the involutions of `G`, together with
`r = 24` (the identity, a totally real field).

No submitted polynomial can ever realize a `(24Tt, r)` pair outside this file;
it is the full target space for the competition.  The table is generated from
Magma's degree-24 transitive group database.

## `lmfdb_baseline.csv`

The frozen LMFDB-derived baseline for the round.  It contains known
polynomials together with their Galois group label, signature, polynomial
discriminant, exact number-field discriminant, scoring discriminant type, and
coefficients.

LMFDB baseline snapshot: 2026-05-20.

The public columns are:

```text
label,r,poly_disc_abs,nfdisc_abs,scoring_disc,coeffs
```

For LMFDB-derived baseline rows, `scoring_disc` is always `nfdisc`, and
`nfdisc_abs` is the exact absolute number-field discriminant.  For a baseline
`(24Tt, r)` pair, the leaderboard threshold `D_base` is the minimum
`nfdisc_abs` among baseline rows for that pair.

For scoring, this file defines both the set of already-known `(24Tt, r)` pairs
and the exact-`nfdisc` improvement threshold for baseline pairs.  A baseline
pair can score only when a participant submission has a successfully computed
exact `nfdisc` strictly below `D_base`.  Mixed discriminants do not unlock
baseline pairs.

Generated from the LMFDB degree-24 data.

Before public launch, freeze both files in git.
