# Number-Field Discriminant Benchmark

This directory contains an exact-first workflow for computing a supported
discriminant value for a polynomial input.

It is an experiment for scoring design, not part of the real-time
submission verifier.  The goal is to measure whether exact field
discriminants are practical for IGP24 degree-24 data.

## Method

For coefficients in ascending order

```text
a_0,a_1,...,a_n
```

the tool first sends the polynomial to PARI/GP as `Polrev([...])` and computes:

- `poldisc(f)`: the polynomial discriminant;
- `nfdisc(f)`: the exact number-field discriminant.

The second value is the intrinsic discriminant of `Q[x]/(f)`.  GP `nfdisc`
is run with a timeout, defaulting to 60 seconds.  If it succeeds, the output
`disc_source` is `exact_nfdisc`.

If GP times out or fails, the tool falls back to a Magma implementation of
David Roe's mixed discriminant:

- exact number-field discriminant valuations for primes `p < bound`;
- polynomial-discriminant contribution for the remaining large-prime part.

The fallback output has `disc_source=mixed_disc`.

## Single Polynomial

```bash
python3 competition/tools/number_field_discriminant/discriminant calculator \
  --coeffs=-2,0,0,1
```

## Batch CSV/TSV

The input file must have a `coeffs` column.  An `id` column is optional.
Files ending in `.tsv` are parsed as tab-separated; all others are parsed
as CSV.

```bash
python3 competition/tools/number_field_discriminant/discriminant calculator \
  input.tsv \
  --output field_discriminants.csv \
  --timeout 60
```

Some degree-24 inputs need more PARI stack than the GP default.  Use
`--stack 512M` or similar when benchmarking hard cases:

```bash
python3 competition/tools/number_field_discriminant/discriminant calculator \
  input.tsv \
  --output field_discriminants.csv \
  --timeout 180 \
  --stack 512M
```

Output columns:

```text
id,status,disc_source,degree,poly_disc,poly_disc_abs,field_disc,field_disc_abs,mixed_disc,mixed_disc_abs,score_disc,score_disc_abs,nfdisc_runtime_sec,mixed_runtime_sec,runtime_sec,error
```

Use `--limit N` for quick profiling samples.
