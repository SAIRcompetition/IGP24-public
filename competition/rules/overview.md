# IGP24: The Inverse Galois Problem in Degree 24

## Overview

IGP24 is an open mathematical discovery competition centered on the inverse
Galois problem over $\mathbb{Q}$, the field of rational numbers.

The [inverse Galois problem](https://en.wikipedia.org/wiki/Inverse_Galois_problem)
asks whether every finite group arises as the
[Galois group](https://en.wikipedia.org/wiki/Galois_group) of a
[number field](https://en.wikipedia.org/wiki/Algebraic_number_field).  A
concrete degree-by-degree version asks the following: for every positive
integer $d$ and every transitive
[permutation group](https://en.wikipedia.org/wiki/Permutation_group) $G$ on
$d$ letters, does there exist an
[irreducible polynomial](https://en.wikipedia.org/wiki/Irreducible_polynomial)
with integer coefficients whose Galois group is $G$?

For $d = 24$, this becomes a large explicit search problem.  There are 25,000
transitive permutation groups of degree 24, conventionally labelled `24T1`
through `24T25000`.  The goal of IGP24 is to find explicit irreducible integer
polynomials of degree 24 that realize as many of these groups, and as many of
their possible signatures, as possible.

## Co-organizers

IGP24 is co-organized by (in alphabetical order by surname):

- John Jones
- Jen Paulhus
- David Roe
- Andrew Sutherland
- Terence Tao

IGP24 is run in collaboration with the [LMFDB](https://www.lmfdb.org/).

[<img src="https://www.lmfdb.org/static/images/lmfdb-logo.png" alt="LMFDB logo" width="200">](https://www.lmfdb.org/)

## Mathematical Background

The inverse Galois problem is widely believed to have a positive answer: every
finite group should occur as a Galois group over $\mathbb{Q}$.  In the
degree-specific form used here, a submitted polynomial

$$
f(x) = a_0 + a_1 x + \cdots + a_{24}\, x^{24}
$$

defines a degree 24 number field when it is irreducible over $\mathbb{Q}$.
Its Galois group acts transitively on the 24 complex roots of $f$, and
[Magma](https://magma.maths.usyd.edu.au/magma/) identifies this transitive
group by a label `24Tt`.

The problem is known to be essentially solved in smaller degrees: realizations
are known for all transitive groups of degree $d \leq 22$, and for all but one
case in degree $d \leq 23$.  The remaining degree 23 case is the
[Mathieu group M23](https://en.wikipedia.org/wiki/Mathieu_group_M23), also
known as `23T5`, which appears as a FrontierMath
[inverse Galois open problem](https://epoch.ai/frontiermath/open-problems/inverse-galois).

Degree 24 is much less complete.  Existing tabulations either focus on smaller
degrees, such as the [Klüners-Malle database](http://galoisdb.math.uni-paderborn.de/home),
or contain only limited degree 24 coverage relative to the full set of 25,000
groups.  The [LMFDB](https://www.lmfdb.org/) provides public data and a
complete degree 24 group index at
[LMFDB Galois groups with n = 24](https://www.lmfdb.org/GaloisGroup/?n=24).
The frozen LMFDB-derived scoring baseline used by this repository covers 286
distinct `24Tt` labels and 622 distinct $(24\mathrm{T}t, r)$ pairs.

[Shafarevich's theorem on solvable Galois groups](https://en.wikipedia.org/wiki/Shafarevich%27s_theorem_on_solvable_Galois_groups)
implies that every finite
[solvable group](https://en.wikipedia.org/wiki/Solvable_group) occurs as a
Galois group over $\mathbb{Q}$.  This matters enormously in degree 24: 24,193
of the 25,000 transitive groups are solvable.  However, the theorem is not a
practical catalog of explicit small polynomials, and it does not by itself
give the kind of verified coefficient lists needed for this competition.

## Task

Participants submit integer polynomials of degree 24.  The official verifier
computes, for each valid polynomial:

- the `24Tt` Galois group label,
- $r$ = number of real roots.

The official scoring discriminant is computed separately by
[PARI/GP](https://pari.math.u-bordeaux.fr/).  For non-baseline pairs, it is
the exact number-field discriminant when that computation succeeds for the
whole pair, and otherwise the documented mixed discriminant described below.
For LMFDB baseline improvements, only a successfully computed exact `nfdisc`
can score.  The precise protocol is specified in [evaluation](evaluation.md).

The number $r$ is the number of real roots of the polynomial, equivalently the
number of real embeddings of the corresponding degree 24 field.  In degree 24,
$r$ must be an even number between $0$ and $24$, but not every value of $r$ is
possible for every group $G$; the allowed signatures depend on the group
structure.  Across all 25,000 degree 24 transitive groups, there are 165,836
possible $(24\mathrm{T}t, r)$ combinations.

A submission contributes to the leaderboard when it realizes a scoreable
`24Tt` label and signature pair $(24\mathrm{T}t, r)$.  Scoreable pairs include
new pairs outside the frozen LMFDB-derived baseline, and baseline pairs that
are unlocked by a strict discriminant improvement as described below.

## Scoring Update (June 18): LMFDB Baseline Improvements

The frozen LMFDB baseline is no longer only a hard exclusion.  A baseline
$(24\mathrm{T}t, r)$ pair can now be unlocked for scoring if a participant
finds a polynomial whose exact number-field discriminant is strictly smaller
than the best baseline discriminant for that pair.

For a baseline pair, let $D_{\mathrm{base}}$ be the smallest exact `nfdisc`
value recorded in the LMFDB baseline.  A participant scores on that pair only
if their exact `nfdisc` is successfully computed and satisfies
$D < D_{\mathrm{base}}$.  Mixed discriminants do not unlock LMFDB baseline
pairs.

When a baseline pair is unlocked, LMFDB is treated as one baseline team in the
scoring formula, and only participant teams beating $D_{\mathrm{base}}$ count
for that pair.

## Timeline

- Competition opens: **June 16, 2026**
- Competition closes: **August 15, 2026**,
  [AoE](https://en.wikipedia.org/wiki/Anywhere_on_Earth) (Anywhere on Earth)

## Submission Format

The official submission artifact is a plain text file named `submission.txt`.

Each non-empty, non-comment line contains one polynomial as 25 comma-separated
integer coefficients in ascending powers of $x$, i.e. $a_0, a_1, \ldots, a_{24}$:

```text
a_0,a_1,...,a_24
```

For example:

```text
COEFFICIENTS_REMOVED
```

This represents $a monic degree 24 polynomial$.

The official Magma verifier computes the Galois group label and signature.
Scoring discriminants are computed separately by the PARI/GP discriminant
workflow.

You may, however, annotate any line with a trailing `#` comment -- including
your own expected `(24Tt, r)` -- and you may add full-line `#` comments
anywhere.  All comments are ignored by the verifier and never affect scoring.

### Monic polynomials (required)

Submissions must be monic: every coefficient line must have $a_{24} = 1$ (and
$a_0 \neq 0$). Non-monic polynomials are rejected.

If you produced a non-monic polynomial $f(x) = a_0 + a_1 x + \cdots + a_{24}\,
x^{24}$ with $a_{24} > 1$, convert it to the monic polynomial defining the same
number field before submitting:

$$
g(x) := a_{24}^{23} f\left(\dfrac{x}{a_{24}}\right),
$$

which is monic of degree 24 with integer coefficients. Equivalently, the
coefficients of $g$ are

$$
g_k = a_k \cdot a_{24}^{23 - k}, \qquad k = 0, 1, \ldots, 24.
$$

Note that $|{\mathrm{disc}}(g)|$ is typically *much* larger than
$|{\mathrm{disc}}(f)|$, so the monic requirement can raise the absolute
discriminant of the polynomial you submit.

## Submission Limits

- each team may initially make at most **5 submissions per day**, whether
  submitted through the SAIR competition website or via API call,
- after a team has been credited with at least **5 distinct scoreable
  $(24\mathrm{T}t, r)$ pairs**, including unlocked baseline improvements, its
  limit increases to **100 submissions per day**,
- each submission may contain at most **100 polynomials**,
- the raw `submission.txt` file size limit is **100,000 bytes**.

Organizers may revise these limits during the competition based on submission
volume and evaluator capacity.

## Scoring

The main objective is to realize as many new $(24\mathrm{T}t, r)$ pairs as
possible.  Scoreable pairs are either verified pairs outside the frozen
LMFDB-derived baseline, or LMFDB baseline pairs unlocked by a strict exact
`nfdisc` improvement over $D_{\mathrm{base}}$.

For each scoreable pair, let $k$ be the number of credited teams for that
pair.  Each participant team contributes at most one count to $k$ for that
pair; for unlocked baseline pairs, LMFDB also counts as one baseline team.
For each scoring participant team, let $D$ be that team's best official
scoring discriminant for the pair, and let $D_0$ be the smallest such value
among all credited teams for that pair.  The team's score for that pair is

$$
2^{1-k}\cdot\frac{\log D_0}{\log D}.
$$

Any logarithm base gives the same score, since only the ratio of logarithms is
used.  A team that is the only one to realize a non-baseline scoreable pair
receives 1 point for that pair.  For an unlocked baseline pair, LMFDB counts
as one baseline team, so a single participant team beating
$D_{\mathrm{base}}$ receives 0.5 points.  If several teams
realize the same pair, the value of the pair is shared exponentially, while
smaller discriminants give a mild bonus.  Two participant teams that submit
polynomials defining the same number field both count as teams finding the same
$(24\mathrm{T}t, r)$ pair.

Within a single submission, if a team submits multiple polynomials that verify
to the same $(24\mathrm{T}t, r)$ pair, only the first verified polynomial for
that pair in the original `submission.txt` line order is considered for that
submission.  Participants should therefore submit only one polynomial for a
given expected $(24\mathrm{T}t, r)$ pair within a single submission: the one
they believe has the smallest scoring discriminant.  In a later submission,
the same team may submit another polynomial to improve its value of $D$ for
the same pair, but that team still contributes one count to $k$.

The official scoring discriminant $D$ is selected by pair, not by row.  For a
scoreable non-baseline $(24\mathrm{T}t, r)$ pair, the evaluator first tries to
compute absolute number-field discriminants using PARI/GP `nfdisc` with a
60-second timeout per polynomial.  If every such computation succeeds for that
pair, those number-field discriminants are used as $D$.  If any such
computation times out or fails, the entire non-baseline pair is scored with
the mixed discriminant using prime bound $100000$: exact local number-field
discriminant contributions for primes below the bound, and the
polynomial-discriminant contribution for the remaining large-prime part.

LMFDB baseline improvements use the stricter rule in the June 18 update:
mixed discriminants cannot unlock baseline pairs, and only a successfully
computed exact `nfdisc` with $D < D_{\mathrm{base}}$ is scoreable.  See
[evaluation](evaluation.md) for the precise schema and evaluator behavior.

## Verification

The mathematical verifier is Magma, a computational algebra system widely used
in computational number theory and group theory.  A polynomial counts only if
Magma verifies that it is irreducible of degree 24 and computes a transitive
degree 24 Galois group label.

The verifier records the computed group label, signature, and status:

```text
computed_label, computed_r, status
```

Internal evaluator files may carry the submitted coefficient string so that the
same polynomial can be passed from Magma to PARI/GP.  User-facing responses and
public leaderboards do not echo submitted coefficients.

The PARI/GP discriminant workflow computes the polynomial, number-field,
mixed, and official scoring discriminants when available.  Participant
responses and public leaderboard data may include these discriminants and the
score components for scoreable pairs.  The exact output fields and pair-level
mixed-discriminant behavior are specified in [evaluation](evaluation.md).

## Why This Is Hard

Degree 24 is large enough that brute-force search becomes expensive, while the
space of possible groups and signatures is enormous.  Random sparse
polynomials often land in common large groups, repeated constructions can
rediscover already-covered signatures, and some groups require much more
targeted algebraic structure.

Good submissions may use computational algebra, targeted constructions,
specialization, composita, local constraints, modular factorization patterns,
resolvents, class field constructions, or other methods.  The competition
rewards verifiable mathematical output, not the method used to find it.

## Competition Integrity

IGP24 rewards newly verified mathematical coverage, not claims about coverage.
Participants may use computational algebra systems, public databases, papers,
preprints, code search, LLMs, agents, and collaborative workflows.  What
matters for scoring is that the submitted polynomials verify correctly
against the official Magma pipeline and improve on the frozen official
baseline.

Invalid competition progress includes:

1. presenting an official-baseline $(24\mathrm{T}t, r)$ pair as a new
   discovery, or as a scoreable baseline improvement without a strict exact
   `nfdisc` improvement over $D_{\mathrm{base}}$,
2. repeatedly submitting duplicate, sign-changed, translated, scaled, or
   otherwise trivially equivalent variants only to waste evaluation resources,
3. including claimed `24Tt`, `r`, discriminant, or metadata columns that try to
   bypass official verification,
4. exploiting parser edge cases, malformed text, timeouts, nondeterminism, or
   implementation details of the verifier,
5. modifying the frozen LMFDB-derived baseline, verifier, or scoring scripts
   and presenting the resulting scores as official,
6. using private organizer-only data, hidden test outputs, or leaked baseline
   updates.

Organizers may request enough provenance to reproduce or audit a high-scoring
submission.  Public mathematical sources are allowed, but participants should
cite them when a submitted polynomial is taken from or directly adapted from
existing work.  Once the competition opens, official scoring is against the
baseline frozen in git for that round.

## Verification Tools

For reference, the competition page provides:

- the Magma verifier used to compute the `24Tt` label and signature `r`,
- the PARI/GP discriminant calculator used for exact `nfdisc` and mixed
  discriminant calculations,
- the LMFDB baseline CSV, available as a static download from the competition
  website, used for official baseline comparisons.

Computing the `24Tt` label locally requires access to Magma.  The PARI/GP
discriminant calculations and the LMFDB baseline file can be inspected
independently.  The scoring algorithm is described in detail in
[evaluation](evaluation.md).

## Team Participation and Anti-Cheating Policy

Each individual or organization can participate in only one team.
Team size is not capped.  This is intended to better support collaboration,
including larger groups that combine mathematical insight, computation,
software engineering, and AI-assisted workflows.
Teams may add members during the competition, subject to organizer approval
and platform support, but teams may not merge after either team has submitted.
Participants are encouraged to collaborate within their registered team and
form teams before submitting.
If coordinated cheating is detected (including sockpuppet teams), all related
teams will be disqualified.

## Community Feedback

Questions and feedback on the rules, scoring, and evaluation procedures are
welcome.

Join the SAIR Foundation Zulip community for discussion and collaboration:
<https://zulip.sair.foundation/>
