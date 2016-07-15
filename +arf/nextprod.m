function m = nextprod(ks, n)
%NEXTPROD finds the next integer that is a multiple of specified factors
%
%  M = NEXTPROD(KS, N) returns the smallest integer >= N that can be
%  written as PROD(FS .^ PS) for a vector FS that contains the unique FACTORs of
%  the entries in KS, and for some integer vector PS.
%
%  In other words, the following criteria are met:
%  - M >= N, and
%  - all prime factors of M are present in KS or are factors of some entry in
%    KS), and
%  - (M - N) is minimized, given the other two constraints.
%
%  EXAMPLE:
%
%  We wish to zeropad a vector of length N = 37033 before taking its FFT. The
%  FFT is fastest for lengths with small prime factors.
%
%  >> N = 37033;
%  >> M = nextprod([2 3 5 7], N); % => M = 37044
%
%  37044 - N is just 11. So our M-length FFT should run about as fast as the
%  next power-of-2-long FFT (64K) but with nearly half the memory requirement.
%
%  Inspired by Julia 0.4's `nextprod`:
%  http://docs.julialang.org/en/release-0.4/stdlib/math/#Base.nextprod. I
%  couldn't figure out the Julia nextprod's source code so this is my
%  brute-force attempt. Could definitely be improved.
%
%  N.B. Julia's nextprod is a bit more general than this version because Julia
%  considers KS as is, without the prime factor restriction that this one has.
%  I.e., `nextprod([4], 7)` in Julia would return 16, which is the smallest
%  power of 4 greather than 7. This function would return 8, which is the
%  smallest power of 2 greater than 7, since it considers the *prime factors* of
%  4, not 4 itself.

% get a sorted and unique list of factors of ks (in case `ks === [4 6 8]`, we
% want `ks = [2 3]`).
ks = unique(cell2mat(arrayfun(@factor, round(ks), 'un', 0)));
% require sanity
assert(all(ks > 1 & isfinite(ks)));
assert(~isempty(ks))

% find a ceiling to our search: find the _smallest_ `min(k)^p` that is `>= n`.
% There are probably better ceilings?
kmin = min(ks);
mmax = kmin ^ ceil(log(n) / log(kmin));

% now just search all these potential `m`'s to find one whose factors are all in
% `ks`.
for m = n : mmax
  if isempty(setdiff(factor(m), ks))
    break;
  end
end

