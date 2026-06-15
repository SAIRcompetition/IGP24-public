# IGP24 Evaluation

This document specifies the evaluation protocol for IGP24.

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
- the coefficient gcd is $1$ (automatic for monic polynomials),
- no polynomial syntax such as `a monic degree 24 polynomial`,
- no extra fields on the coefficient line itself: a coefficient line is 25
  integers and nothing else (no claimed `24Tt`, $r$, or discriminant columns).

Coefficients must be listed in ascending powers, constant term $a_0$ first.

You may annotate any line with a trailing `#` comment -- including your own
expected $(24\mathrm{T}t, r)$ -- and may add full-line `#` comments anywhere.
All comments are ignored by the verifier and never affect scoring.

You may submit up to 10 polynomials for the same $(24\mathrm{T}t, r)$ pair
(since finding multiple polynomials with small discriminant is helpful),
however you should not submit multiple polynomials defining the same number
field merely by changing generators. Such duplicates consume the shared Magma
verification budget and slow evaluation for everyone. For leaderboard
scoring, we retain only the lowest-discriminant submission for each number
field class.

## Duplicate Number Fields

Two verified polynomials are treated as duplicates for scoring if they define
isomorphic number fields over $\mathbb{Q}$:

```text
Q[x]/(f) ~= Q[x]/(g)
```

The following trivial transformations are common examples of same-field
duplicates:

1. $P(x) \mapsto P(x - a)$ for any $a \in \mathbb{Q}$,
2. $P(x) \mapsto P(-x)$,
3. $P(x) \mapsto x^{24}P(1/x)$.

They do not exhaust all duplicates: two different generators of the same
number field can have different minimal polynomials and different polynomial
discriminants.

For scoring, full duplicate detection is by number-field isomorphism. Within
each $(24\mathrm{T}t, r)$ bucket, verified rows are sorted by
$|{\mathrm{disc}}(f)|$. A new row is compared only against current scoring
field representatives. The default implementation uses PARI/GP `nfisisom`
directly for the number-field isomorphism check. An older optional
`magma-gp` strategy is also available for experiments: Magma
`PossiblyIsomorphic` first rules out definitely different fields, and GP
`nfisisom` checks the surviving pairs.

The verifier may still return a canonical representative for the smaller
trivial-transformation orbit. This is useful diagnostic information, but the
leaderboard deduplication unit is the number-field class, not the orbit class.

## Verification Pipeline

The official pipeline is:

1. Parse `submission.txt`.
2. Convert accepted lines into the TSV format consumed by the Magma batch
   harness.
3. Run Magma verification using `public package/verifier/t24.m`.
4. Keep only rows with `status=ok`.
5. Comparelicate verified rows by number-field class using PARI/GP
   `nfisisom` by default.
6. Score against the official baseline.

The verifier returns:

```text
computed_label, computed_r, poly_disc_abs, verification_key, status
```

`computed_r` is the number of real roots.  `poly_disc_abs` is
$|{\mathrm{disc}}(f)|$, the absolute value of the polynomial discriminant.
`verification_key` is the canonical representative for the smaller
trivial-transformation orbit, as a comma separated list of rational numbers.
It is not the scoring deduplication key.

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
  --baseline competition/baseline/lmfdb_baseline.csv \
  --summary /tmp/igp24_summary.json \
  --novel-pairs /tmp/igp24_novel_pairs.csv
```

## Official Baseline

The official baseline is:

```text
competition/baseline/lmfdb_baseline.csv
```

It contains known polynomials, together with their Galois group, signature,
polynomial discriminant, and number field discriminant. The polynomial
discriminant is the scoring quantity; the number-field discriminant may be
used internally for same-field filtering but is not itself a scoring metric.

The baseline consists of the frozen LMFDB snapshot, and the baseline used for
official scoring is frozen in git.

## Leaderboard Metrics

Scoring is computed independently for each $(24\mathrm{T}t, r)$ pair:

1. All verified submissions for the pair, together with the official baseline
   entries, are deduplicated by number-field class. The baseline participates
   in the ranking as an independent team ("LMFDB"). For a fixed number-field
   class, only rows achieving the smallest submitted
   $|{\mathrm{disc}}(f)|$ for that class can receive credit; higher
   discriminant generators of the same field score zero. If the official
   baseline already achieves that smallest discriminant for the field class,
   participant submissions defining the same field with the same discriminant
   receive no credit; a strictly lower-discriminant defining polynomial can
   still replace the baseline representative.
2. The deduplicated number-field classes are ranked by $|{\mathrm{disc}}|$. Each
   distinct $|{\mathrm{disc}}|$ value occupies exactly one rank: the smallest
   is worth $m = 10$ points, the next $m = 9$, and so on down to $m = 1$.
   Only the 10 smallest distinct values score; field classes at larger values
   are valid but receive no points.
3. If the scoring field classes at a given $|{\mathrm{disc}}|$ value are
   represented by $k$ distinct teams, each of those teams receives
   $m / 2.1^{\,k-1}$ points (a team represented by several such classes at the
   same value counts once). A unique discovery earns the full $m$;
   equal-discriminant collisions reduce every collider's award exponentially.
   Points attributed to LMFDB are awarded to no participant.

Note that this means that your leaderboard score can decrease if others later
submit polynomials with smaller absolute discriminant (pushing your rank's
value down) or non-equivalent polynomials with the same absolute discriminant
(increasing $k$).  Trading polynomials between teams cannot increase the
traders' combined score: a higher-discriminant duplicate of an already-scoring
number field scores zero, and an equal-discriminant collision strictly
decreases the total points awarded.

## Confidentiality and Teams

Submission contents are confidential during the competition.  The leaderboard
displays only scores and the best $|{\mathrm{disc}}|$ per
$(24\mathrm{T}t, r)$ pair — never coefficients.  All submissions are
published after the competition ends.

Team membership must be publicly displayed.  Each team consists of 1 to 5
members.

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
  same-field variants only to inflate row counts,
- acquiring another team's polynomials, by trade or otherwise: such
  submissions score zero when they are higher-discriminant duplicates of the
  same number field or strictly decrease the total points awarded when they
  create an equal-discriminant collision,
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
