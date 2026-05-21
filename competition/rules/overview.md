# IGP24: The Inverse Galois Problem in Degree 24

## Overview

IGP24 is an open mathematical discovery competition centered on the inverse
Galois problem over `Q`, the field of rational numbers.

The [inverse Galois problem](https://en.wikipedia.org/wiki/Inverse_Galois_problem)
asks whether every finite group arises as the
[Galois group](https://en.wikipedia.org/wiki/Galois_group) of a
[number field](https://en.wikipedia.org/wiki/Algebraic_number_field).  A
concrete degree-by-degree version asks the following: for every positive
integer `d` and every transitive
[permutation group](https://en.wikipedia.org/wiki/Permutation_group) `G` on
`d` letters, does there exist an
[irreducible polynomial](https://en.wikipedia.org/wiki/Irreducible_polynomial)
with integer coefficients whose Galois group is `G`?

For `d = 24`, this becomes a large explicit search problem.  There are 25,000
transitive permutation groups of degree 24, conventionally labelled `24T1`
through `24T25000`.  The goal of IGP24 is to find explicit irreducible integer
polynomials of degree 24 that realize as many of these groups, and as many of
their possible signatures, as possible.

## Organizers

IGP24 is organized by (in alphabetical order by surname):

- John Jones
- Jen Paulhus
- David Roe
- Andrew Sutherland
- Terence Tao

## Mathematical Background

The inverse Galois problem is widely believed to have a positive answer: every
finite group should occur as a Galois group over `Q`.  In the degree-specific
form used here, a submitted polynomial

```text
f(x) = a_0 + a_1 x + ... + a_24 x^24
```

defines a degree 24 number field when it is irreducible over `Q`.  Its Galois
group acts transitively on the 24 complex roots of `f`, and Magma identifies
this transitive group by a label `24Tn`.

The problem is known to be essentially solved in smaller degrees: realizations
are known for all transitive groups of degree `d <= 22`, and for all but one
case in degree `d <= 23`.  The remaining degree 23 case is the
[Mathieu group M23](https://en.wikipedia.org/wiki/Mathieu_group_M23), also
known as `23T5`, which appears as a FrontierMath
[inverse Galois open problem](https://epoch.ai/frontiermath/open-problems/inverse-galois).

Degree 24 is much less complete.  Existing tabulations either focus on smaller
degrees, such as the [Klüners-Malle database](http://galoisdb.math.uni-paderborn.de/home),
or contain only limited degree 24 coverage relative to the full set of 25,000
groups.  The [LMFDB](https://www.lmfdb.org/) provides public data and a
complete degree 24 group index at
[LMFDB Galois groups with `n = 24`](https://www.lmfdb.org/GaloisGroup/?n=24).
The frozen LMFDB-derived baseline used by this repository contains 18,252
degree 24 number-field records, covering 286 distinct `24Tn` labels and 622
distinct `(24Tn, r)` pairs.

[Shafarevich's theorem on solvable Galois groups](https://en.wikipedia.org/wiki/Shafarevich%27s_theorem_on_solvable_Galois_groups)
implies that every finite
[solvable group](https://en.wikipedia.org/wiki/Solvable_group) occurs as a
Galois group over `Q`.  This matters enormously in degree 24: 24,193 of the
25,000 transitive groups are solvable.  However, the theorem is not a practical
catalog of explicit small polynomials, and it does not by itself give the kind
of verified coefficient lists needed for this competition.

## Task

Participants submit integer polynomials of degree 24.  The official verifier
computes, for each valid polynomial:

```text
24Tn Galois group label
r = number of real roots
abs(discriminant of f)
```

The number `r` is the number of real roots of the polynomial, equivalently the
number of real embeddings of the corresponding degree 24 field.  In degree 24,
`r` must be an even number between 0 and 24, but not every value of `r` is
possible for every group `G`; the allowed signatures depend on the group
structure.  Across all 25,000 degree 24 transitive groups, there are 165,836
possible `(24Tn, r)` combinations.

A submission is useful when it realizes a new `24Tn` label or a new pair
`(24Tn, r)` not already present in the official baseline.

## Submission Format

The official submission artifact is a plain text file named `submission.txt`.

Each non-empty, non-comment line contains one polynomial as 25 comma-separated
integer coefficients in ascending powers of `x`:

```text
a_0,a_1,...,a_24
```

For example:

```text
COEFFICIENTS_REMOVED
```

This represents `a monic degree 24 polynomial`.

Participants do not submit claimed Galois groups, signatures, or
discriminants.  These are computed by the official Magma verifier.

## Scoring

The leaderboard is ranked lexicographically by:

1. number of new `24Tn` labels found,
2. number of new `(24Tn, r)` pairs found,
3. lower total discriminant among the best representatives for those pairs.

The official baseline is published as a list of known `(24Tn, r)` pairs.  A
polynomial that only realizes a baseline pair is valid, but it does not improve
the coverage score.

Not all realizations are equally valuable.  For a fixed pair `(G, r)`, smaller
discriminants are typically more useful.  Computing the
[discriminant of a number field](https://en.wikipedia.org/wiki/Discriminant_of_an_algebraic_number_field)
can be difficult, especially because factoring large discriminants may be hard.
IGP24 therefore scores using the absolute value of the
[polynomial discriminant](https://en.wikipedia.org/wiki/Discriminant), which is
easy to compute and is divisible by the number-field discriminant.  This avoids
penalizing submissions merely because their polynomial discriminants are hard
to factor.

## Verification

The mathematical verifier is Magma.  A polynomial counts only if Magma verifies
that it is irreducible of degree 24 and computes a transitive degree 24 Galois
group label.

The verifier records:

```text
computed_label, computed_r, poly_disc_abs
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
matters for scoring is that the submitted coefficient lines verify correctly
against the official Magma pipeline and improve on the frozen official
baseline.

The following do not count as valid competition progress:

1. submitting polynomials already present in the official baseline or public
   organizer reference examples as if they were new,
2. submitting duplicate, sign-changed, translated, scaled, or otherwise
   trivially equivalent variants only to inflate row counts,
3. including claimed `24Tn`, `r`, discriminant, or metadata columns that try to
   bypass official verification,
4. exploiting parser edge cases, malformed text, timeouts, nondeterminism, or
   implementation details of the verifier,
5. modifying the official baseline, verifier, or scoring scripts and presenting
   the resulting scores as official,
6. using private organizer-only data, hidden test outputs, or leaked baseline
   updates.

Organizers may request enough provenance to reproduce or audit a high-scoring
submission.  Public mathematical sources are allowed, but participants should
cite them when a submitted polynomial is taken from or directly adapted from
existing work.  Once the competition opens, official scoring is against the
baseline frozen in git for that round.

## Experimental Status

This is a draft SAIR competition package.  Rules, scoring weights, resource
limits, and publication policy may be adjusted before launch.
