# IGP24 Project Workspace

IGP24 is a project workspace for turning the degree 24 inverse Galois problem
over $\mathbb{Q}$ into a reproducible mathematical discovery competition.

## Co-organizers

IGP24 is co-organized by (in alphabetical order by surname):

- John Jones
- Jen Paulhus
- David Roe
- Andrew Sutherland
- Terence Tao

IGP24 is run in collaboration with the [LMFDB](https://www.lmfdb.org/).

[<img src="https://www.lmfdb.org/static/images/lmfdb-logo.png" alt="LMFDB logo" width="200">](https://www.lmfdb.org/)

## Background

The [inverse Galois problem](https://en.wikipedia.org/wiki/Inverse_Galois_problem)
asks whether every finite group occurs as the
[Galois group](https://en.wikipedia.org/wiki/Galois_group) of a
[number field](https://en.wikipedia.org/wiki/Algebraic_number_field).  In the
degree-specific form used here, the question becomes: for each transitive
[permutation group](https://en.wikipedia.org/wiki/Permutation_group) $G$ on
$24$ letters, can we find an
[irreducible polynomial](https://en.wikipedia.org/wiki/Irreducible_polynomial)
with integer coefficients whose Galois group is $G$?

Degree 24 is a large concrete test case.  There are 25,000 transitive groups
of degree 24, labelled `24T1` through `24T25000`.  A stronger target is to
realize not only each group $G$, but each possible signature $(G, r)$, where
$r$ is the number of real roots of the polynomial.  Across all degree 24
transitive groups there are 165,836 possible $(24\mathrm{T}t, r)$ combinations.

Smaller degrees are much better understood: all transitive groups of degree
$d \leq 22$ are known to be realized, and degree $d \leq 23$ is missing only
the [Mathieu group M23](https://en.wikipedia.org/wiki/Mathieu_group_M23), also
known as `23T5`, which appears in the FrontierMath
[inverse Galois open problems](https://epoch.ai/frontiermath/open-problems/inverse-galois).
Degree 24 remains far less complete.  The public
[LMFDB](https://www.lmfdb.org/) and the
[Klüners-Malle database](http://galoisdb.math.uni-paderborn.de/home) provide
important known examples, but they do not give explicit realizations for all
25,000 degree 24 groups.

The frozen LMFDB-derived scoring baseline in this repository covers 286
distinct `24Tt` labels and 622 distinct $(24\mathrm{T}t, r)$ pairs.
[Shafarevich's theorem](https://en.wikipedia.org/wiki/Shafarevich%27s_theorem_on_solvable_Galois_groups)
implies that all finite
[solvable groups](https://en.wikipedia.org/wiki/Solvable_group) occur over
$\mathbb{Q}$, and 24,193 of the 25,000 degree 24 transitive groups are
solvable.  The theorem is existential, however; it does not provide the
explicit coefficient lists that this project and competition are trying to
build.

For every candidate polynomial $f(x) \in \mathbb{Z}[x]$ of degree $24$, the
verifier records:

- the `24Tt` Galois group label,
- $r$, the number of real roots of $f$,
- $|{\mathrm{disc}}(f)|$, the absolute value of the polynomial
  discriminant.

The competition score is focused on new verified $(24\mathrm{T}t, r)$ pairs
outside the frozen LMFDB baseline.  The official scoring discriminant is
computed by the evaluation pipeline: PARI/GP `nfdisc` is attempted with a
fixed timeout, and the documented mixed discriminant is used if that attempt
does not succeed.

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
competition/baseline/lmfdb_baseline.csv
competition/examples/sample_submission.txt
competition/tools/
competition/competition.yaml
```

This is what should be copied or published as the competition package.

## Public Tools

Beyond the frozen LMFDB baseline (286 `24Tt` labels, 622 $(24\mathrm{T}t, r)$
pairs), this project constructed and Magma-verified many new degree 24
polynomials, substantially extending the known coverage. Two independent
search workspaces contributed:

| Workspace | new `24Tt` labels | new $(24\mathrm{T}t, r)$ pairs |
|---|---:|---:|
| SAIR | 434 | 999 |
| SAIR | 2 978 | 7 110 |
| **Union, beyond LMFDB** | **2 999** | **7 300** |

Together with the LMFDB baseline, these public package currently cover **3 285**
distinct `24Tt` labels and **7 922** distinct $(24\mathrm{T}t, r)$ pairs. Every
discovery is an explicit integer polynomial verified by Magma; novelty is a
strict set difference against the frozen 2026-05-20 LMFDB snapshot (809 of the
new pairs were found independently by both workspaces).

The verified public package, with one explicit polynomial per result, live in
`public package/materials/`:

```text
public package/materials/README.md      ← "look here first" entry guide
                  baseline_pairs.tsv   main file (tab-separated): label, r, coeffs — one row per pair
                  baseline_pairs.csv   full audit table (source, family, params, |disc|, ...)
                  summary.json                machine-readable headline counts
                  strategies.md               prose summary of the construction strategies
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

These discovery files are reference research outputs, not the scoring
baseline.  The contestant-facing baseline for this round is
`competition/baseline/lmfdb_baseline.csv` unless the organizers explicitly
freeze a broader baseline before launch.

## Core Verifier

The canonical single-polynomial verifier is:

```text
public package/verifier/t24.m
```

Mathematical claims should be treated as valid only after Magma verification.
