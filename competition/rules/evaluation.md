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
however you should not submit trivial equivalent variants (sign changes,
translations, scaling, duplicates) since this consumes the shared Magma
verification budget and slows evaluation for everyone.
We will compute a canonical representative for each input polynomial, and
only retain one submission from each orbit class (see the next section for
more details).

## Equivalent Submissions

We say that two polynomials are equivalent if one can be obtained from the
other by a sequence of transformations of the following form:

1. $P(x) \mapsto P(x - a)$ for any $a \in \mathbb{Q}$,
2. $P(x) \mapsto P(-x)$,
3. $P(x) \mapsto x^{24}P(1/x)$.

We call each equivalence class an **orbit class**.  Two polynomials in the
same orbit class have the same discriminant, the same Galois group, and the
same signature, so we do not count them as unique submissions.

As a fast deduplication key, we compute a canonical representative by zeroing
out the $x^{23}$ term from each of $P(x)$, $P(-x)$, $x^{24}P(1/x)$ and
$x^{24}P(-1/x)$ and picking the one with the lexicographically least
primitive rescaling.  Polynomials with the same canonical representative are
always equivalent, but the key is not a complete invariant: certain
compositions of the transformations above (nested reciprocal–translations)
produce equivalent polynomials with different canonical representatives.
Full equivalence is therefore decided by a pairwise Möbius check: within each
$(24\mathrm{T}t, r, |{\mathrm{disc}}|)$ bucket we numerically test whether
some Möbius transformation maps the roots of one polynomial bijectively onto
the roots of the other.  We will return the canonical representative for each
input.

## Verification Pipeline

The official pipeline is:

1. Parse `submission.txt`.
2. Convert accepted lines into the TSV format consumed by the Magma batch
   harness.
3. Run Magma verification using `public package/verifier/t24.m`.
4. Keep only rows with `status=ok`.
5. Comparelicate verified rows by orbit class (pairwise Möbius matching within
   each $(24\mathrm{T}t, r, |{\mathrm{disc}}|)$ bucket) and assign each row
   an `orbit_class_id`.
6. Score against the official baseline.

The verifier returns:

```text
computed_label, computed_r, poly_disc_abs, verification_key, status
```

`computed_r` is the number of real roots.  `poly_disc_abs` is
$|{\mathrm{disc}}(f)|$, the absolute value of the polynomial discriminant.
`verification_key` is the canonical representative defined above, as a comma
separated list of rational numbers.

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
polynomial discriminant, and number field discriminant (the last is just for
mathematical interest; the number field discriminant does not play a role in
this contest).  A valid polynomial equivalent to one in the baseline is
accepted but will score no points.

The baseline consists of the frozen LMFDB snapshot, and the baseline used for
official scoring is frozen in git.

## Leaderboard Metrics

Scoring is computed independently for each $(24\mathrm{T}t, r)$ pair:

1. All verified submissions for the pair, together with the official baseline
   entries, are deduplicated by orbit class.  The baseline participates in
   the ranking as an independent team ("LMFDB").  Each orbit class is owned
   by exactly one team: the first to submit a polynomial in that class, by
   submission timestamp (baseline classes are owned by LMFDB).  Later
   submissions in an already-owned orbit class score zero and do not affect
   the owner's score.
2. The deduplicated orbit classes are ranked by $|{\mathrm{disc}}|$.  Each
   distinct $|{\mathrm{disc}}|$ value occupies exactly one rank: the smallest
   is worth $m = 10$ points, the next $m = 9$, and so on down to $m = 1$.
   Only the 10 smallest distinct values score; orbit classes at larger values
   are valid but receive no points.
3. If the orbit classes at a given $|{\mathrm{disc}}|$ value are owned by $k$
   distinct teams, each of those teams receives $m / 2.1^{\,k-1}$ points
   (a team owning several such classes at the same value counts once).  A
   unique discovery earns the full $m$; equal-discriminant collisions reduce
   every collider's award exponentially.  Points attributed to LMFDB are
   awarded to no participant.

Note that this means that your leaderboard score can decrease if others later
submit polynomials with smaller absolute discriminant (pushing your rank's
value down) or non-equivalent polynomials with the same absolute discriminant
(increasing $k$).  Trading polynomials between teams cannot increase the
traders' combined score: a duplicate of an already-submitted orbit class
scores zero, and an equal-discriminant collision strictly decreases the total
points awarded.

## Confidentiality and Teams

Submission contents are confidential during the competition.  The leaderboard
displays only scores and the best $|{\mathrm{disc}}|$ per
$(24\mathrm{T}t, r)$ pair — never coefficients.  All submissions are
published after the competition ends.  Submission timestamps are
authoritative for pair-based ownership.

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
  trivially equivalent variants only to inflate row counts,
- acquiring another team's polynomials, by trade or otherwise: such
  submissions score zero (same orbit class, pair-based rule) or strictly
  decrease the total points awarded (equal-discriminant collision),
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
