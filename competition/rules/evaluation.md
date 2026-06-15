# IGP24 Evaluation

This document specifies the evaluation protocol for IGP24.  The
participant-facing summary is `overview.md`; this file is the technical source
for parser rules, verifier outputs, discriminant computation, and leaderboard
fields.

## Submission Artifact

A submission is a single plain text file:

```text
submission.txt
```

Each non-empty line contains one degree 24 integer polynomial as 25
comma-separated coefficients in ascending powers, i.e. $a_0, a_1, \ldots, a_{24}$:

```text
a_0,a_1,...,a_24
```

Lines beginning with `#` are comments and are ignored.

Example (the polynomial $a monic degree 24 polynomial$):

```text
# a monic degree 24 polynomial
COEFFICIENTS_REMOVED
```

## Coefficient Rules

Each polynomial line must satisfy:

- exactly 25 integer coefficients,
- $a_0 \neq 0$,
- $a_{24} = 1$ (submissions must be monic; non-monic polynomials are rejected —
  see `overview.md` for converting a non-monic polynomial to the monic one
  defining the same number field),
- coefficient-only format: a coefficient line is exactly 25 decimal integers.

Coefficients must be listed in ascending powers, constant term $a_0$ first.

You may annotate any line with a trailing `#` comment -- including your own
expected $(24\mathrm{T}t, r)$ -- and may add full-line `#` comments anywhere.
All comments are ignored by the verifier and never affect scoring.

## Submission Limits

Each submission must satisfy:

- at most 100 valid polynomial lines,
- raw `submission.txt` size at most 100,000 bytes.

Each team may initially make at most 5 submissions per day, whether submitted
through the SAIR competition website or via API call.  After a team has been
credited with at least 5 distinct scoreable $(24\mathrm{T}t, r)$ pairs, its
limit increases to 100 submissions per day.

Organizers may revise these limits during the competition based on submission
volume and evaluator capacity.

Within a single submission, if multiple submitted polynomials verify to the
same $(24\mathrm{T}t, r)$ pair, only the first verified polynomial for that
pair in the original `submission.txt` line order is considered for that
submission.  The first verified polynomial is determined after parser and
Magma validation.  Participants should therefore submit only one polynomial
for a given expected $(24\mathrm{T}t, r)$ pair within a single submission: the
one they believe has the smallest scoring discriminant.

Later submissions may improve a team's official scoring discriminant for a
pair.  Across all submissions, each team can receive credit at most once for a
given $(24\mathrm{T}t, r)$ pair and contributes at most one count to the
number of teams finding that pair.

## Scoring Unit

The scoring unit is the verified $(24\mathrm{T}t, r)$ pair together with the
team.  The scoreable pairs are the verified pairs outside the official
LMFDB-derived baseline.

If two teams submit polynomials defining the same number field and the same
scoreable $(24\mathrm{T}t, r)$ pair, both teams count as teams that found that
pair.  This keeps the first phase focused on realizing as many group and
signature pairs as possible.

## Verification Pipeline

The official pipeline is:

1. Parse `submission.txt`.
2. Convert accepted lines into the TSV format consumed by the Magma batch
   harness.
3. Run Magma verification using `public package/verifier/t24.m`.
4. Keep only rows with `status=ok`.
5. For each submission, keep only the first verified polynomial for each
   $(24\mathrm{T}t, r)$ pair, using the original line order in
   `submission.txt`.
6. Keep the rows whose $(24\mathrm{T}t, r)$ pair lies outside the official
   LMFDB-derived baseline.
7. Compute the official scoring discriminant $D$ for those rows.
8. For each team and scoreable pair, keep the row with the smallest $D$ across
   all of that team's submissions.
9. Score by team and $(24\mathrm{T}t, r)$ pair.

The verifier returns:

```text
computed_label, computed_r, status
```

`computed_r` is the number of real roots.  Internal evaluator files may carry
the submitted coefficient string so that the same polynomial can be passed
from Magma to PARI/GP.  User-facing responses and public leaderboards do not
echo submitted coefficients.

The scoring-discriminant step then records:

```text
poly_disc_abs, field_disc_abs, mixed_disc_abs, scoring_disc_abs, disc_source
```

`poly_disc_abs` is the absolute polynomial discriminant computed by PARI/GP,
not by the Magma verifier.  `field_disc_abs` is the absolute number-field
discriminant when `nfdisc` succeeds.  `mixed_disc_abs` is the mixed
discriminant used as fallback and for pair-level mixed scoring.  Finally,
`scoring_disc_abs` is the value of $D$ used in the leaderboard formula.
`disc_source` is `exact_nfdisc` when the pair is scored with number-field
discriminants and `mixed_disc` when the pair is scored with mixed
discriminants.  The scoring key is the verified pair together with the team.

If `nfdisc` times out or fails for a row but the mixed discriminant is computed
successfully, the row remains scoreable with `disc_source=mixed_disc`.  A
timeout or error status is reserved for rows whose supported scoring
discriminant could not be computed.

The user-facing response should not echo submitted coefficients.  For accepted
polynomials, it may report `computed_label`, `computed_r`, the available
discriminants above, and the score components for each scoreable pair:
`k_teams`, `other_teams_count`, `best_scoring_disc_abs`, `scoring_disc_abs`,
`disc_source`, and `points`.

## Local Validation

Run Magma verification:

```bash
./competition/tools/submission verifier \
  competition/examples/sample_submission.txt \
  /tmp/igp24_verified.csv \
  2
```

Score the verified result:

```bash
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

## Official Baseline

The official baseline is the frozen LMFDB-derived baseline:

```text
competition/baseline/lmfdb_baseline.csv
```

It contains known polynomials, together with their Galois group, signature,
polynomial discriminant, and number field discriminant.  For official scoring,
the baseline is used to define the set of already-known
$(24\mathrm{T}t, r)$ pairs.

The baseline consists of the frozen LMFDB snapshot, and the baseline used for
official scoring is frozen in git.

## Leaderboard Metrics

Scoring is computed independently for each verified
$(24\mathrm{T}t, r)$ pair outside the official baseline, meaning the frozen
LMFDB-derived baseline:

1. Within a single submission from one team, only the first verified polynomial
   for that pair in the original line order is considered.
2. Across later submissions, the same team may improve its official scoring
   discriminant $D$ for that pair.  The team still contributes only once to
   the number of teams finding the pair.
3. Let $k$ be the number of teams that have at least one valid submission for
   the pair.  Let $D$ be one team's best official scoring discriminant for the
   pair, and let $D_0$ be the smallest such value among all teams.  That team
   receives

   $$
   2^{1-k}\cdot\frac{\log D_0}{\log D}
   $$

   points for the pair.

Any logarithm base gives the same score, since only the ratio of logarithms is
used.  If a team is the only team to realize a scoreable pair, then $k=1$ and
$D=D_0$, so the pair is worth 1 point.  If several teams realize the same pair,
the exponential factor shares the value of the pair, while the logarithmic
factor mildly rewards smaller discriminants.

The official scoring discriminant $D$ is produced by the evaluation pipeline
using the following fixed pair-level protocol:

1. For each scoreable $(24\mathrm{T}t, r)$ pair, try to compute the absolute
   number-field discriminant of every considered row with PARI/GP `nfdisc`,
   using a 60-second timeout per polynomial.
2. If all `nfdisc` computations for that pair succeed, use those absolute
   number-field discriminants as the values of $D$ for that pair.
3. If any `nfdisc` computation for that pair times out or fails, use the mixed
   discriminant for every considered row in that pair.  This is a pair-level
   flag: once triggered, all teams' scoreable rows for that
   $(24\mathrm{T}t,r)$ pair are evaluated with `mixed_disc_abs`.  The mixed
   discriminant uses prime bound $100000$: exact local number-field
   discriminant contributions for primes $p < 100000$ and the
   polynomial-discriminant contribution for the remaining large-prime part.

If a row cannot supply the discriminant required by the pair-level source
selection, that row is not scoreable for that leaderboard run and is reported
in the evaluator's ignored counts.

The evaluator records which source was used for each pair.  The recorded value
of $D$ is final for that leaderboard run.

## Public Outputs and Policy Hooks

During the competition, public leaderboard outputs may display scores,
verified pair coverage, the number of teams credited for each pair, the best
public scoring discriminant for each pair, and the discriminant source used
for each pair.  They do not display submitted polynomial coefficients.

The evaluator treats claimed labels, signatures, discriminants, and metadata
columns in `submission.txt` as comments or invalid input; official values are
computed only by the parser, Magma verifier, PARI/GP discriminant workflow, and
scoring reference.  If a submitted polynomial is taken from or directly
adapted from an existing public source, participants should cite that source
in their submission notes or related provenance.  Organizers may request
provenance or reproduction notes for high-scoring submissions.

Team membership, collaboration, confidentiality, and anti-cheating policy are
summarized for participants in `overview.md`.
