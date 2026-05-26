# IGP24 Evaluation

This document specifies the draft evaluation protocol for IGP24.

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
- $a_{24} > 0$ (monic, $a_{24} = 1$, is recommended but not required — see
  `overview.md` for the standard non-monic → monic transformation),
- the coefficient gcd is $1$,
- no polynomial syntax such as `a monic degree 24 polynomial`,
- no extra fields on the coefficient line itself: a coefficient line is 25
  integers and nothing else (no claimed `24Tt`, $r$, or discriminant columns).

Coefficients are listed in ascending powers, constant term $a_0$ first.  The
verifier itself accepts either coefficient order, but fixing the ascending
convention makes every submission unambiguous and easy to validate.

You may annotate any line with a trailing `#` comment -- including your own
expected $(24\mathrm{T}t, r)$ -- and may add full-line `#` comments anywhere.
All comments are ignored by the verifier and never affect scoring.

Duplicate coefficient lines are ignored after the first occurrence.  Submit
only your single best (smallest-discriminant) polynomial for each
$(24\mathrm{T}t, r)$ pair: trivially equivalent variants (sign changes,
translations, scalings, duplicates) cannot improve your score, and they only
consume the shared Magma verification budget and slow evaluation for everyone.

## Verification Pipeline

The official pipeline is:

1. Parse `submission.txt`.
2. Convert accepted lines into the TSV format consumed by the Magma batch
   harness.
3. Run Magma verification using `public package/verifier/t24.m`.
4. Keep only rows with `status=ok`.
5. Comparelicate by verified $(24\mathrm{T}t, r)$ pair, retaining the
   representative with the smallest `poly_disc_abs`.
6. Score against the official baseline.

The verifier returns:

```text
computed_label, computed_t, computed_r, poly_disc_abs, status
```

`computed_r` is the number of real roots.  `poly_disc_abs` is
$|{\mathrm{disc}}(f)|$, the absolute value of the polynomial discriminant.

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
python3 competition/tools/scoring reference \
  /tmp/igp24_verified.csv \
  --baseline competition/baseline/baseline_pairs.csv \
  --summary /tmp/igp24_summary.json \
  --novel-pairs /tmp/igp24_novel_pairs.csv
```

## Official Baseline

The draft baseline is:

```text
competition/baseline/baseline_pairs.csv
```

It contains known $(24\mathrm{T}t, r)$ pairs.  A valid polynomial realizing a
baseline pair is accepted but scores no coverage point for that pair.

The draft baseline currently includes the frozen LMFDB snapshot plus the public
reference examples under `public package/materials/`.  Those examples document
reference progress, but they are not intended to be scoreable public package.

The baseline may be refreshed before launch. Once the competition opens, the
baseline used for official scoring should be frozen in git.

## Leaderboard Metrics

For a verified submission, define:

- `new_label_count`: number of distinct verified `24Tt` labels not present in
  the official baseline,
- `new_pair_count`: number of distinct verified $(24\mathrm{T}t, r)$ pairs not
  present in the official baseline,
- `discriminant_tiebreak`: the sum of $\log_{10}(\texttt{poly\_disc\_abs})$
  over the best representative for each new pair, where smaller is better.

The primary leaderboard ranking is lexicographic:

```text
new_label_count          descending
new_pair_count           descending
discriminant_tiebreak    ascending
```

The public summary may also report an integer convenience score:

$$
10^6 \cdot \texttt{new\_label\_count} \;+\; \texttt{new\_pair\_count}.
$$

The convenience score is not a substitute for the full lexicographic ranking.

## Resource Limits

Draft limits:

- maximum lines per submission: TBD,
- maximum raw `submission.txt` size: TBD,
- maximum coefficient absolute value: TBD,
- total Magma wall-clock budget: TBD.

The current local tools do not enforce final resource limits.  They only check
syntax and canonical coefficient conditions.

## Invalid Rows

A line may fail before Magma if it violates the text format.  A line may fail
inside Magma if the polynomial is reducible, has the wrong degree, or otherwise
cannot be assigned a valid degree 24 transitive Galois group.

Invalid rows score zero.  They do not invalidate the rest of the submission
unless the official resource limits are exceeded.

## Anti-Cheating Policy

Submissions must contain genuine candidate polynomials and must be evaluated
against the official frozen baseline and Magma verifier.  Participants may use
public mathematical sources, computational tools, LLMs, agents, and
collaboration, but leaderboard credit is only for verified coverage that is not
already in the official baseline.

The following do not count as valid competition progress:

- submitting baseline polynomials or public organizer reference examples as
  new public package,
- submitting duplicate, sign-changed, translated, scaled, or otherwise
  trivially equivalent variants only to inflate row counts,
- corrupting the submitted text to exploit parser differences, timeout
  behavior, nondeterminism, or other implementation details,
- including claimed labels, signatures, discriminants, or metadata columns that
  attempt to influence official scoring,
- attempting to modify or bypass the official baseline, Magma verifier, or
  scoring scripts,
- using private organizer-only data, hidden test outputs, or leaked baseline
  updates.

The scoring object is verified mathematical coverage, not claimed coverage.
Organizers may request provenance or reproduction notes for high-scoring
submissions, especially when a result appears to come from an existing public
source.
