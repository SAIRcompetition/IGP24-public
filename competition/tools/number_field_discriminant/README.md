# Number-Field Discriminant Tool

This directory contains the discriminant workflow used to support pair-level
leaderboard scoring.

It is separate from the real-time Magma verifier.  The verifier remains the
source of truth for the Galois label and signature; this tool supplies the
official scoring discriminant used by the leaderboard.

## Method

For coefficients in ascending order

```text
a_0,a_1,...,a_n
```

the tool first sends the polynomial to PARI/GP as `Polrev([...])` and computes:

- `nfdisc(f)`: the exact number-field discriminant.

This is the intrinsic discriminant of `Q[x]/(f)`.  GP `nfdisc` is run with a
timeout, defaulting to 60 seconds.  The tool also computes the mixed
discriminant, so the scorer can switch an entire `(24Tt, r)` pair to mixed
discriminants if any row in that pair times out or fails during `nfdisc`.

The GP implementation of the mixed discriminant uses:

- exact number-field discriminant valuations for primes `p < bound`;
- polynomial-discriminant contribution for the remaining large-prime part.

Rows whose `nfdisc` computation succeeds have `disc_source=exact_nfdisc`.
Rows whose `nfdisc` computation times out or fails and whose mixed
discriminant computation succeeds have `disc_source=mixed_disc`.

The official round configuration is `--timeout 60 --mixed-bound 100000`.
The discriminator output includes row-level `score_disc_abs`, but the final
leaderboard output uses `scoring_disc_abs` after applying the pair-level source
selection.

The competition verifier remains the source of truth for `T` and `r`.
Polynomial discriminants are not part of the official verifier output; GP's
mixed-discriminant script computes the polynomial discriminant internally when
it needs the large-prime contribution.

## Single Polynomial

```bash
python3 competition/tools/number_field_discriminant/discriminant calculator \
  --coeffs=-2,0,0,1
```

## Batch CSV/TSV

The input file must have a `coeffs` column.  An `id` or `entry_id` column
is optional and is preserved as the output `id`.  Files ending in `.tsv` are
parsed as tab-separated; all others are parsed as CSV.

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
id,status,disc_source,degree,field_disc,field_disc_abs,mixed_disc,mixed_disc_abs,score_disc,score_disc_abs,nfdisc_runtime_sec,mixed_runtime_sec,runtime_sec,error
```

Use `--limit N` for quick profiling samples.
