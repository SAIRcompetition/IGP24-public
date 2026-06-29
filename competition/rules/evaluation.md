# IGP24 Evaluation

This document specifies the evaluation protocol for IGP24.  The
participant-facing summary is [overview](overview.md); this file is the
technical source for parser rules, verifier outputs, discriminant computation,
and leaderboard fields.

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

Example from the LMFDB baseline, representing $x^{24} + 2$:

```text
2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
```

## Coefficient Rules

Each polynomial line must satisfy:

- exactly 25 integer coefficients,
- $a_0 \neq 0$,
- $a_{24} = 1$ (submissions must be monic; non-monic polynomials are rejected —
  see [overview](overview.md) for converting a non-monic polynomial to the monic one
  defining the same number field),
- coefficient-only format: a coefficient line is exactly 25 decimal integers.

Coefficients must be listed in ascending powers, constant term $a_0$ first.

You may annotate any line with a trailing `#` comment -- including your own
expected $(24\mathrm{T}t, r)$ -- and may add full-line `#` comments anywhere.
All comments are ignored by the verifier and never affect scoring.

## Submission Limits

Each submission must satisfy:

- at most 1,000 valid polynomial lines,
- raw `submission.txt` size at most 1,000,000 bytes.

Each team may make at most 1,000 submissions per day, whether submitted
through the SAIR competition website or via API call.

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
team.  A scoreable pair is either:

- a verified pair outside the official LMFDB-derived baseline, or
- a baseline pair unlocked by a participant row whose exact `nfdisc` is
  successfully computed and strictly smaller than $D_{\mathrm{base}}$.

If two participant teams submit polynomials defining the same number field and
the same scoreable $(24\mathrm{T}t, r)$ pair, both teams count as teams that
found that pair.  This keeps the first phase focused on realizing as many
group and signature pairs as possible.

For baseline pairs, mixed discriminants cannot unlock scoring.  A participant
row with `nfdisc` timeout, `nfdisc` failure, or only a mixed discriminant does
not beat the baseline.

## Verification Pipeline

The official pipeline is:

1. Parse `submission.txt`.
2. Convert accepted lines into the TSV format consumed by the Magma batch
   harness.
3. Run Magma verification using the reference verifier described below.
4. Keep only rows with `status=ok`.
5. For each submission, keep only the first verified polynomial for each
   $(24\mathrm{T}t, r)$ pair, using the original line order in
   `submission.txt`.
6. Compute the discriminant data for the remaining verified rows.
7. Classify each row as either a non-baseline pair candidate or a baseline
   improvement candidate.
8. For non-baseline pairs, apply the standard pair-level exact/mixed
   discriminant protocol.
9. For baseline pairs, keep only rows with a successfully computed exact
   `nfdisc` satisfying $D < D_{\mathrm{base}}$.
10. For each team and scoreable pair, keep the row with the smallest official
    scoring discriminant $D$ across all of that team's submissions.
11. Score by team and $(24\mathrm{T}t, r)$ pair.

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

For non-baseline pairs, if `nfdisc` times out or fails for a row but the mixed
discriminant is computed successfully, the row remains scoreable with
`disc_source=mixed_disc`.  For baseline pairs, the mixed fallback is not
scoreable: only exact `nfdisc` rows with $D < D_{\mathrm{base}}$ can unlock
the pair.  A baseline row with only mixed discriminant data is not scoreable
even if the discriminant workflow itself completed successfully.  Rows with
`timeout` or `error` status are never scoreable.

The user-facing response should not echo submitted coefficients.  For accepted
polynomials, it may report `computed_label`, `computed_r`, the available
discriminants above, and the score components for each scoreable pair:
`k_teams`, `other_teams_count`, `best_scoring_disc_abs`, `scoring_disc_abs`,
`disc_source`, and `points`.

## Reference Programs

The following programs are provided for reference and reproducibility.  The
official competition service remains the source of truth for accepted
submissions, verified results, and leaderboard updates.

### Reference Magma Verifier

Computing the `24Tt` label requires access to
[Magma](https://magma.maths.usyd.edu.au/magma/).  The reference Magma verifier
checks that a coefficient string defines an irreducible degree 24 polynomial,
then computes the degree-24 transitive group label and the number of real
roots.

```magma
function t24polydata(s)
/*
    Given a string containing a sequence of integers representing an
    irreducible polynomial f(x) of degree 24, returns:
    - the T-number of the Galois group of f(x)
    - the number of real roots of f(x)
    - the absolute value of the discriminant of f(x)
    and otherwise 0,0,0 is returned.

    Reversing the order of coefficients will not change the results
    so they can be ordered either by increasing powers of x or by
    decreasing powers of x, there is no need to fix a convention.
*/
    regex := "[ \t]*[+-]?[0-9]+([ \t]*,[ \t]*[+-]?[0-9]+)*[ \t]*";
    b,s := Regexp(regex,s);
    if not b then return 0,0,0; end if;
    a := [Integers()|StringToInteger(c):c in Split(s,",")];
    if #a ne 25 or a[1] eq 0 or a[#a] eq 0 then return 0,0,0; end if;
    R<x> := PolynomialRing(Integers());
    f := R!a;
    if not IsIrreducible(f) then return 0,0,0; end if;
    n := TransitiveGroupIdentification(GaloisGroup(f));
    r := NumberOfRealRoots(f);
    d := Abs(Discriminant(f));
    return n,r,d;
end function;

function t24labeldata(s)
/*
    Given a string containing a sequence of integers representing an
    irreducible polynomial f(x) of degree 24, returns:
    - the T-number of the Galois group of f(x)
    - the number of real roots of f(x)
    and otherwise 0,0 is returned.

    This lighter path is used by the competition verifier, where scoring
    discriminants are computed separately by PARI/GP.
*/
    regex := "[ \t]*[+-]?[0-9]+([ \t]*,[ \t]*[+-]?[0-9]+)*[ \t]*";
    b,s := Regexp(regex,s);
    if not b then return 0,0; end if;
    a := [Integers()|StringToInteger(c):c in Split(s,",")];
    if #a ne 25 or a[1] eq 0 or a[#a] eq 0 then return 0,0; end if;
    R<x> := PolynomialRing(Integers());
    f := R!a;
    if not IsIrreducible(f) then return 0,0; end if;
    n := TransitiveGroupIdentification(GaloisGroup(f));
    r := NumberOfRealRoots(f);
    return n,r;
end function;

/*
   Example command:

     magma -b f:="2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1" t24.m
*/
if assigned f then
    n,r,d := t24polydata(f);
    printf "%o,%o,%o\n",n,r,d;
    exit;
end if;
```

### Reference PARI/GP Discriminant Calculator

The official scoring discriminant is computed separately from the Magma
verifier.  For a polynomial with coefficients listed in ascending powers, use
`Polrev([a0,a1,...,a24])` in [PARI/GP](https://pari.math.u-bordeaux.fr/).
The exact number-field discriminant is computed with
[`nfdisc`](https://pari.math.u-bordeaux.fr/dochtml/html/General_number_fields.html#nfdisc),
which returns the discriminant of the number field defined by a monic
irreducible polynomial.  The evaluator attempts `nfdisc` with a 60-second
timeout.  The polynomial discriminant `poldisc(f)` is also computed as an
auxiliary value.

For non-baseline pairs, if any relevant `nfdisc` computation for that pair
times out or fails, the whole pair is scored with the mixed discriminant
below, using bound `100000`.

```gp
\\ Computes the product of local nfdisc at small primes and the remaining
\\ large part of poldisc.
mixed_disc(f, B = 100000) = {
  my(D = poldisc(f));
  my(sgn = sign(D));
  my(abs_D = abs(D));
  my(F = factor(abs_D, B));
  my(small_primes = []);
  my(small_part = 1);

  \\ 1. Identify small primes and calculate their total contribution to poldisc
  for(i = 1, #F~,
    my(p = F[i, 1]);
    my(e = F[i, 2]);
    if(p < B,
      small_primes = concat(small_primes, p);
      small_part *= p^e;
    );
  );

  \\ If no small primes are found within the bound, return the original poldisc
  if(#small_primes == 0, return(D));

  \\ 2. Isolate the large part of poldisc, coprime to small primes
  my(large_part = abs_D / small_part);

  \\ 3. Compute the maximized local discriminant for just the small primes
  my(small_nf_disc = abs(nfdisc([f, small_primes])));

  \\ 4. Recombine the parts and restore the correct discriminant sign
  return(sgn * small_nf_disc * large_part);
}
```

Example PARI/GP session:

```gp
f = Polrev([2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]);
abs(nfdisc(f))
abs(poldisc(f))
abs(mixed_disc(f, 100000))
```

For baseline pairs, the mixed fallback is disabled: only a successfully
computed exact `nfdisc` strictly below $D_{\mathrm{base}}$ can unlock and
score on a baseline pair.

## Official Baseline

The official baseline is the frozen LMFDB-derived baseline CSV, available as
a static download from the competition website.

It contains known polynomials, together with their Galois group, signature,
absolute polynomial discriminant `poly_disc_abs`, exact number-field
discriminant `nfdisc_abs`, scoring discriminant type `scoring_disc`, and
coefficients.  For official scoring, the baseline is used both to define the
set of already-known $(24\mathrm{T}t, r)$ pairs and to define the improvement
threshold $D_{\mathrm{base}}$ for each baseline pair.

The baseline consists of the frozen LMFDB snapshot, and the baseline used for
official scoring is frozen in git.

For a baseline $(24\mathrm{T}t, r)$ pair, $D_{\mathrm{base}}$ is the smallest
`nfdisc_abs` recorded for that pair in the baseline.  The
current LMFDB-derived baseline has exact `nfdisc` values for all 622 baseline
pairs, so baseline improvements are compared only against exact `nfdisc`
values.

## Leaderboard Metrics

Scoring is computed independently for each scoreable
$(24\mathrm{T}t, r)$ pair:

1. Within a single submission from one team, only the first verified polynomial
   for that pair in the original line order is considered.
2. Across later submissions, the same team may improve its official scoring
   discriminant $D$ for that pair.  The team still contributes only once to
   the number of teams finding the pair.
3. Let $k$ be the number of credited teams for the pair.  Each participant
   team contributes at most one count to $k$; for unlocked baseline pairs,
   LMFDB also counts as one baseline team.  For each scoring participant team,
   let $D$ be that team's best official scoring discriminant for the pair, and
   let $D_0$ be the smallest such value among all credited teams.  That
   participant team receives

   $$
   2^{1-k}\cdot\frac{\log D_0}{\log D}
   $$

   points for the pair.

Any logarithm base gives the same score, since only the ratio of logarithms is
used.  If a participant team is the only team to realize a non-baseline
scoreable pair, then $k=1$ and $D=D_0$, so the pair is worth 1 point.  For an
unlocked baseline pair, LMFDB counts as one baseline team, so a single
participant team beating $D_{\mathrm{base}}$ has $k=2$ and receives 0.5
points.  If several teams realize the same pair, the exponential factor shares
the value of the pair, while the logarithmic factor mildly rewards smaller
discriminants.

For an unlocked baseline pair, only participant teams with exact `nfdisc`
values strictly smaller than $D_{\mathrm{base}}$ count for the pair, so
$k = 1 +$ the number of participant teams beating $D_{\mathrm{base}}$.  The
value $D_0$ is the smallest discriminant among $D_{\mathrm{base}}$ and all
beating participant teams.

For non-baseline pairs, the official scoring discriminant $D$ is produced by
the evaluation pipeline using the following fixed pair-level protocol:

1. For each scoreable non-baseline $(24\mathrm{T}t, r)$ pair, try to compute
   the absolute number-field discriminant of every considered row with PARI/GP
   `nfdisc`, using a 60-second timeout per polynomial.
2. If all `nfdisc` computations for that pair succeed, use those absolute
   number-field discriminants as the values of $D$ for that pair.
3. If any `nfdisc` computation for that pair times out or fails, use the mixed
   discriminant for every considered row in that pair.  This is a pair-level
   flag: once triggered, all teams' scoreable rows for that
   $(24\mathrm{T}t,r)$ pair are evaluated with `mixed_disc_abs`.  The mixed
   discriminant uses prime bound $100000$: exact local number-field
   discriminant contributions for primes $p < 100000$ and the
   polynomial-discriminant contribution for the remaining large-prime part.

For baseline pairs, this mixed fallback is disabled.  A row unlocks and scores
only if its exact `nfdisc` is successfully computed and strictly smaller than
$D_{\mathrm{base}}$.  Equality with $D_{\mathrm{base}}$, a larger exact
`nfdisc`, `nfdisc` timeout, `nfdisc` failure, or mixed-only discriminant data
receives no score for that baseline pair.

If a row cannot supply the discriminant required by the relevant source
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
summarized for participants in [overview](overview.md).
