\\ Computes the product of local nfdisc at small primes and the remaining large part of poldisc.
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
  
  \\ 2. Isolate the large part of poldisc (completely coprime to small primes)
  my(large_part = abs_D / small_part);
  
  \\ 3. Compute the maximized local discriminant for just the small primes
  my(small_nf_disc = abs(nfdisc([f, small_primes])));
  
  \\ 4. Recombine the parts and restore the correct discriminant sign
  return(sgn * small_nf_disc * large_part);
}
