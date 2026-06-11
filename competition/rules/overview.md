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
Its Galois group acts transitively on the 24 complex roots of $f$, and Magma
identifies this transitive group by a label `24Tt`.

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
The frozen LMFDB-derived baseline used by this repository contains 18,252
degree 24 number-field records, covering 286 distinct `24Tt` labels and 622
distinct $(24\mathrm{T}t, r)$ pairs.

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
- $r$ = number of real roots,
- $|{\mathrm{disc}}(f)|$, the absolute value of the polynomial discriminant.

The number $r$ is the number of real roots of the polynomial, equivalently the
number of real embeddings of the corresponding degree 24 field.  In degree 24,
$r$ must be an even number between $0$ and $24$, but not every value of $r$ is
possible for every group $G$; the allowed signatures depend on the group
structure.  Across all 25,000 degree 24 transitive groups, there are 165,836
possible $(24\mathrm{T}t, r)$ combinations.

A submission is useful when it realizes a new `24Tt` label or pair
$(24\mathrm{T}t, r)$ not already present in the official baseline, or when
it lowers the smallest known absolute discriminant for a given pair.

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

Participants do not submit claimed Galois groups, signatures, or
discriminants.  These are computed by the official Magma verifier.

You may, however, annotate any line with a trailing `#` comment -- including
your own expected `(24Tt, r)` -- and you may add full-line `#` comments
anywhere.  All comments are ignored by the verifier and never affect scoring.

### Monic polynomials (recommended, not required)

Monic submissions ($a_{24} = 1$) are **recommended** but **not required**. Any
primitive integer polynomial of degree 24 with $a_0 \neq 0$ and $a_{24} > 0$ is
accepted by the verifier.

If you produced a non-monic polynomial $f(x) = a_0 + a_1 x + \cdots + a_{24}\,
x^{24}$ and want a monic version of the same field, you can use

$$
g(x) := a_{24}^{23} f\left(\dfrac{x}{a_{24}}\right),
$$

which is monic of degree 24 with integer coefficients and defines the same
number field as $f$. Equivalently, the coefficients of $g$ are

$$
g_k = a_k \cdot a_{24}^{23 - k}, \qquad k = 0, 1, \ldots, 24.
$$

Note that $|{\mathrm{disc}}(g)|$ is typically *much* larger than
$|{\mathrm{disc}}(f)|$ (and thus less likely to score points), so converting to
monic is rarely worthwhile when $a_{24} > 1$. Submit whichever form has
the smaller $|{\mathrm{disc}}|$ — the verifier accepts both.

## Scoring

Not all realizations are equally valuable.  For a fixed pair $(G, r)$, smaller
discriminants are typically more useful.  Computing the
[discriminant of a number field](https://en.wikipedia.org/wiki/Discriminant_of_an_algebraic_number_field)
can be difficult because factoring large integers may be hard.
IGP24 therefore scores using the absolute value of the
[polynomial discriminant](https://en.wikipedia.org/wiki/Discriminant), which is
easy to compute and is divisible by the number-field discriminant.  This avoids
penalizing submissions merely because their polynomial discriminants are hard
to factor.

The leaderboard is ranked by assigning points for the smallest absolute discriminant
found for each `(24Tt, r)` pair.  More specifically, the smallest absolute
discriminant for fixed $t$ and $r$ is worth 10 points, the next smallest is worth
9, etc.

Duplicates and ties are resolved by pair-based deduplication with a
pair-based rule: polynomials related by the trivial transformations
(translation, negation, reciprocal) form one **orbit class**, and each orbit
class is credited to the first team to submit it, by submission timestamp —
later equivalent submissions score zero.  If $k$ distinct teams own
non-equivalent polynomials with the same
$(24\mathrm{T}t, r, |\mathrm{disc}|)$, each receives $m/2.1^{\,k-1}$ points
instead of the rank's full value $m$.  The official baseline participates in
the ranking as an independent team ("LMFDB").  See `evaluation.md` for the
precise protocol.

The official baseline is published as a list of known $(24\mathrm{T}t, r, \mathrm{disc})$
triples.  Only the 10 smallest distinct absolute discriminant values in the
ranking (baseline and all teams' submissions combined) score points for a
given $t$ and $r$; a polynomial beyond the 10th distinct value is valid but
scores no points.

You may submit up to 10 polynomials for the same $(24\mathrm{T}t, r)$ pair
(since finding multiple polynomials with small discriminant is helpful),
however you should not submit trivial equivalent variants (sign changes,
translations, scaling, duplicates) since this consumes the shared Magma
verification budget and slows evaluation for everyone.
We will compute a canonical representative for each input polynomial, and
only retain one submission from each orbit class; full equivalence is decided
by a pairwise Möbius check (see `evaluation.md`).

## Verification

The mathematical verifier is [Magma](https://magma.maths.usyd.edu.au/magma/), a
computational algebra system widely used in computational number theory and
group theory.  A polynomial counts only if Magma verifies that it is
irreducible of degree 24 and computes a transitive degree 24 Galois group
label.

The verifier records:

```text
computed_label, computed_r, poly_disc_abs, verification_key, status
```

where `poly_disc_abs` is the absolute value of the polynomial discriminant, not
necessarily the number-field discriminant.

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

The following do not count as valid competition progress:

1. submitting polynomials already present in the official baseline as if they were new,
2. submitting duplicate, sign-changed, translated, scaled, or otherwise
   trivially equivalent variants,
3. including claimed `24Tt`, `r`, discriminant, or metadata columns that try to
   bypass official verification,
4. exploiting parser edge cases, malformed text, timeouts, nondeterminism, or
   implementation details of the verifier,
5. modifying the official baseline, verifier, or scoring scripts and presenting
   the resulting scores as official,
6. using private organizer-only data, hidden test outputs, or leaked baseline
   updates.

Team membership must be publicly displayed; there is no limit on team size.
Trading polynomials between teams is unprofitable by design: a duplicate of
an already-submitted orbit class scores zero, and an equal-discriminant
collision strictly decreases the total points awarded.

Organizers may request enough provenance to reproduce or audit a high-scoring
submission.  Public mathematical sources are allowed, but participants should
cite them when a submitted polynomial is taken from or directly adapted from
existing work.  Once the competition opens, official scoring is against the
baseline frozen in git for that round.

## Experimental Status

This is a draft SAIR competition package.  Rules, scoring weights, resource
limits, and publication policy may be adjusted before launch.
