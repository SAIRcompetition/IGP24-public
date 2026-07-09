# Number-Field Discriminant Reference

This directory contains the public PARI/GP reference code for the mixed
discriminant used by IGP24.

The production evaluator computes the official scoring discriminant inside the
SAIR competition system.  This reference file is provided so participants can
reproduce the mathematical definition.

## Method

For coefficients in ascending order

```text
a_0,a_1,...,a_n
```

PARI/GP represents this polynomial as `Polrev([...])`.  The relevant built-ins
are:

- `poldisc(f)`: the polynomial discriminant;
- `nfdisc(f)`: the exact number-field discriminant.

The second value is the intrinsic discriminant of `Q[x]/(f)`.  In the
competition evaluator, GP `nfdisc` is run with a 60-second timeout.  If any
accepted non-baseline row for a fixed `(24Tt, r)` pair falls back from exact
`nfdisc`, that whole pair is scored with the mixed discriminant.

As of July 9, the GP implementation of the mixed discriminant is
operationally defined as:

```gp
nfdisc([f, bound])
```

with the official bound `100000`.  This replaces the earlier product-form
implementation and makes mixed-discriminant computation simpler and more
efficient.

Rows whose `nfdisc` computation succeeds have `disc_source=exact_nfdisc`.
Rows whose `nfdisc` computation times out or fails and whose mixed
discriminant computation succeeds have `status=ok` and
`disc_source=mixed_disc`.  A `timeout` or `error` status means the supported
scoring discriminant could not be computed for that row.

LMFDB baseline improvements use a stricter rule in the scorer: a baseline pair
can be unlocked only by a successfully computed exact `nfdisc` strictly below
the baseline threshold `D_base`.  Mixed discriminants do not unlock baseline
pairs.

## Example PARI/GP Session

From the repository root:

```bash
gp -q competition/tools/number_field_discriminant/mixed_disc.gp
```

Then in GP:

```gp
f = Polrev([2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]);
abs(poldisc(f))
abs(nfdisc(f))
abs(mixed_disc(f, 100000))
```
