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

## Reference Tools

This public package includes only the core reference tools:

- `tools/magma/t24.m` for Magma-based computation of the degree-24 group
  label and signature;
- `tools/number_field_discriminant/mixed_disc.gp` for the PARI/GP mixed
  discriminant fallback.

The production submission validator and leaderboard system run inside the
SAIR competition system.

Verification of `T` and `r` uses [Magma](https://magma.maths.usyd.edu.au/magma/);
it must be available on the command line as `magma`.
