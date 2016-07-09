function [new] = nextpowlow(n, maxPrimeFactor, maxPowers)
% NEXTPOWLOW finds the next number with a small prime factorization.
%   M = NEXTPOWLOW(N) will be >= N, and has prime factors <= 7.
%
%   NEXTPOWLOW exhaustively searches all primes <= 7, taken to powers <= 2, for
%   the number that least-exceeds N. That is, it considers a list of factors
%   {p^q, for all p in [3, 5, 7] and q in [0 : 2]} as potential factors of M,
%   along with 2, and finds the factor that, with 2, multiply to produce M so
%   that M - N is small. In other words, M = 2^nextpow2(N / (pBest ^ qBest)) *
%   pBest ^ qBest.
%
%   M = NEXTPOWLOW(N, P) uses P insead of 7 as the largest prime factor.
%
%   M = NEXTPOWLOW(N, P, Q) uses Q instead of 2 as the largest power to
%   consider.
%
%   N.B.: requires enough memory to enumerate Z * (Q + 1) ^ Z values, where Z+1
%   is the number of primes <= P (Z = 3 for P = 7). However, N.B. the second:
%   those are collapsed to just (Q + 1) ^ Z values, which are actually tested.
%   The former can be seen as a memory requirement, while the latter a compute
%   cost.

if (nargin == 0)
  new = 0;
  demo();
  return;
end

if ~exist('maxPrimeFactor', 'var') || isempty(maxPrimeFactor),
  maxPrimeFactor =  7;
end
if ~exist('maxPowers', 'var') || isempty(maxPowers), maxPowers = 2; end

factors = primes(maxPrimeFactor);
factors = factors(factors > 2); % omit 2

omitLarge = @(x) x(x<=n);
argsToNdgrid = arrayfun(@(n) omitLarge(n.^(0 : maxPowers)), factors, 'uniformoutput', 0);

% Matlab has this really poor syntax for rest/spread, i.e., mixing argument
% vectors and data vectors. Here, we're effectively doing 
% `grids = ndgrid(...argsToNdgrid)` in ES6-notation.
grids = cell(1, length(factors));
[grids{:}] = ndgrid(argsToNdgrid{:});

% Elements of grids are hyper-cubes. We just need vectors...
grids = cellfun(@(c) c(:), grids, 'uniformoutput', 0);

% ...so we can collapse them into an exhaustive list of all factors taken to
% power `[0:maxPower]`. All entries in `list` have prime factorizations <=
% `maxPrimeFactor`
list = prod(cell2mat(grids), 2);

% Omit `list` entries that are bigger than n so we don't get fractional results
list = list(list <= n);

% For each factor in `list`, find the smallest number greater than `n` that is a
% product of that factor and 2s.
candidates = 2.^nextpow2(n./list) .* list;

% Find the best such factor, i.e., where the result is least above `n`.
[~, loc] = min(candidates - n);
new = candidates(loc);
end

function [] = demo()
% DEMO finds several numbers' NEXTPOWLOW and times their FFT.
limit = [1e3, 1e6];
numPoints = 1e4;
n = sort(unique([round(logspace(log10(limit(1)), log10(limit(2)), numPoints)), ...
    2.^(ceil(log2(limit(1))) : floor(log2(limit(end))) )]));

pow2 = 2.^nextpow2(n);
low = arrayfun(@nextpowlow, n);

timing_idx = 1:10:length(n);
tmp = randn(n(1), 1) + 1j * randn(n(1), 1);
t_pow2 = arrayfun(@(x) timeit(@() fft(tmp,x)), pow2(timing_idx));
t_low = arrayfun(@(x) timeit(@() fft(tmp,x)), low(timing_idx));

figure;
subplot(121)
semilogx(n, pow2./low, '.-');
lineHandle = line(xlim(), [1 1]);
ylim([0 max(ylim)])
title('Memory savings'); xlabel('input size n'); ylabel('nextpow2 / nextpowlow')
lineHandle.Color='black'; lineHandle.LineWidth=2;

subplot(122)
semilogx(n(timing_idx), t_pow2 ./ t_low,'.-')
lineHandle = line(xlim(), [1 1]);
ylim([0 max(ylim)])
title('FFT speedup'); xlabel('input size n');
lineHandle.Color='black'; lineHandle.LineWidth=2;

end

