\\ Computes the PARI/GP bounded discriminant used as the non-baseline fallback.
mixed_disc(f, B = 100000) = {
  return(nfdisc([f, B]));
}
