# IGP24 Project Workspace

IGP24 is a project workspace for turning the degree 24 inverse Galois problem
over `Q` into a reproducible mathematical discovery competition.

## Background

The [inverse Galois problem](https://en.wikipedia.org/wiki/Inverse_Galois_problem)
asks whether every finite group occurs as the
[Galois group](https://en.wikipedia.org/wiki/Galois_group) of a
[number field](https://en.wikipedia.org/wiki/Algebraic_number_field).  In the
degree-specific form used here, the question becomes: for each transitive
[permutation group](https://en.wikipedia.org/wiki/Permutation_group) `G` on
24 letters, can we find an
[irreducible polynomial](https://en.wikipedia.org/wiki/Irreducible_polynomial)
with integer coefficients whose Galois group is `G`?

Degree 24 is a large concrete test case.  There are 25,000 transitive groups
of degree 24, labelled `24T1` through `24T25000`.  A stronger target is to
realize not only each group `G`, but each possible signature `(G, r)`, where
`r` is the number of real roots of the polynomial.  Across all degree 24
transitive groups there are 165,836 possible `(24Tn, r)` combinations.

Smaller degrees are much better understood: all transitive groups of degree
`d <= 22` are known to be realized, and degree `d <= 23` is missing only the
[Mathieu group M23](https://en.wikipedia.org/wiki/Mathieu_group_M23), also
known as `23T5`, which appears in the FrontierMath
[inverse Galois open problems](https://epoch.ai/frontiermath/open-problems/inverse-galois).
Degree 24 remains far less complete.  The public
[LMFDB](https://www.lmfdb.org/) and the
[Klüners-Malle database](http://galoisdb.math.uni-paderborn.de/home) provide
important known examples, but they do not give explicit realizations for all
25,000 degree 24 groups.

The frozen LMFDB-derived baseline in this repository contains 18,252 degree 24
number-field records, covering 286 distinct `24Tn` labels and 622 distinct
`(24Tn, r)` pairs.  [Shafarevich's theorem](https://en.wikipedia.org/wiki/Shafarevich%27s_theorem_on_solvable_Galois_groups)
implies that all finite
[solvable groups](https://en.wikipedia.org/wiki/Solvable_group) occur over
`Q`, and 24,193 of the 25,000 degree 24 transitive groups are solvable.  The
theorem is existential, however; it does not provide the explicit coefficient
lists that this project and competition are trying to build.

For every candidate polynomial, the verifier records:

```text
24Tn Galois group label
r = number of real roots
abs(discriminant of f)
```

The competition uses the polynomial discriminant, not necessarily the full
number-field discriminant, because it is easy to compute and does not require
factoring large integers.

## Repository Layout

This repository has two main areas:

```text
competition/   public draft competition package
public package/   reference verifier, snapshots, searches, harnesses, docs
```

The project root is intentionally kept clean: no generated CSV, TSV, or log
files should live here. Generated artifacts belong under `competition/`,
`public package/`, or `public package/docs/`.

## Competition Package

`competition/` contains the contestant-facing package:

```text
competition/rules/overview.md
competition/rules/evaluation.md
competition/baseline/baseline_pairs.csv
competition/examples/sample_submission.txt
competition/tools/
competition/competition.yaml
```

This is what should be copied or published as the competition package.

## Public Tools

Beyond the frozen LMFDB baseline, this project constructed and Magma-verified
many new degree 24 polynomials, substantially extending the known coverage.
Two independent search workspaces contributed:

```text
SAIR workspace        : 168 new 24Tn labels, 339 new (24Tn, r) pairs
SAIR workspace  : 214 new 24Tn labels, 313 new (24Tn, r) pairs
Union, beyond LMFDB    : 294 new 24Tn labels, 529 new (24Tn, r) pairs
```

The frozen LMFDB snapshot covers 286 `24Tn` labels and 622 `(24Tn, r)` pairs.
Folding in these public package, the draft baseline now covers 580 distinct
`24Tn` labels and 1,151 distinct `(24Tn, r)` pairs. Every discovery is an
explicit integer polynomial verified by Magma; novelty is a strict set
difference against the frozen 2026-05-20 LMFDB snapshot (123 of the new pairs
were found independently by both workspaces).

The verified public package, with one explicit polynomial per result:

```text
public package/README.md                    reporting entry point and headline counts
public package/materials/               curated verified result tables, including:
  baseline_verification.csv         best representative per new pair
  baseline_pairs.csv                new pairs with construction-strategy metadata
  baseline_labels.csv               new 24Tn labels with their realized r values
  baseline_submission.txt           plain coefficient lists for the new pairs
  summary.json                             machine-readable headline counts
  strategies.md                            how the polynomials were constructed
```

The canonical verifier, frozen snapshot, both search workspaces, and the
reproducible Magma harness that produced these results also live under
`public package/`:

```text
public package/verifier/t24.m               canonical Magma verifier
public package/snapshots/                   frozen LMFDB baseline
public package/search/public/                SAIR search workspace
public package/search/public/          SAIR search workspace
public package/harness/                     reproducible workflow entry points
```

The draft competition baseline folds in these public public package so they
cannot be resubmitted for leaderboard credit.

## Core Verifier

The canonical single-polynomial verifier is:

```text
public package/verifier/t24.m
```

Mathematical claims should be treated as valid only after Magma verification.
