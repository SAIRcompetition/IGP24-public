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
   To use this script from the command line, pass a degree 24 polynomial as
   25 comma-separated coefficients in ascending powers, for example:

     magma -b f:="a_0,a_1,...,a_24" competition/tools/magma/t24.m
*/
if assigned f then
    n,r,d := t24polydata(f);
    printf "%o,%o,%o\n",n,r,d;
    exit;
end if;
