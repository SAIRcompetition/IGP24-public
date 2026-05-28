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
only retain one submission from among those with the same canonical
representative (see the next section for more details).

## Equivalent Submissions

We say that two polynomials are equivalent one can be obtained from the other
by a sequence of transformations of the following form:

1. $P(x) \mapsto P(x - a)$ for any $a \in \mathbb{Q}$,
2. $P(x) \mapsto P(-x)$,
3. $P(x) \mapsto x^{24}P(1/x)$.

Two polynomials in the same equivalence class have the same discriminant,
the same Galois group, and the same signature, so we do not count them as
unique submissions.

We may define a canonical representative within each equivalence class by
choosing zeroing out the $x^{23}$ term from each of $P(x)$, $P(-x)$, $x^{24}P(1/x)$
and $x^{24}P(-1/x)$ and picking the one with the lexicographically least
primitive rescaling.  We will return this canonical representative for each input.

## Verification Pipeline

The official pipeline is:

1. Parse `submission.txt`.
2. Convert accepted lines into the TSV format consumed by the Magma batch
   harness.
3. Run Magma verification using `public package/verifier/t24.m`.
4. Keep only rows with `status=ok`
5. Score against the official baseline.

The verifier returns:

```text
computed_label, computed_t, computed_r, poly_disc_abs, verification_key, status
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

The draft baseline currently includes the frozen LMFDB snapshot.
The baseline may be refreshed before launch. Once the competition opens, the
baseline used for official scoring will be frozen in git.

## Leaderboard Metrics

For a verified submission, we will compare your results to other submissions,
and you get points for having one of the 10 smallest absolute discriminants
for each $(24\mathrm{T}t, r)$ pair.  More specifically, the smallest absolute
discriminant for fixed $t$ and $r$ is worth 10 points, the next smallest is worth
9, etc.  In the presence of ties, points will be divided equally among all
participants who submitted polynomials with that absolute discriminant.

Note that this means that your leaderboard score can decrease if others later
submit polynomials with smaller absolute discriminant.

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
