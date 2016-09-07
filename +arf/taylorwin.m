function win = taylorwin(N, nbar, sll)
% TAYLORWIN generates the Taylor window for apodization, etc.
%
% taylorwin(N, NBAR, SLL) returns an N-element column vector containing the
% Taylor window. NBAR should be an integer specifying the number of sidelobes
% which should have nearly-constant levels. SLL is the peak SideLobe Level
% relative to the mainlobe, in decibels (its sign is ignored).
%
% The window's spectrum will have sidelobes that decay monotonically, with the
% first pair of sidelobes being SLL decibels below the mainlobe. In other words,
% (20*log10(mainlobe) - 20*log10(peak sidelobe)) approximately equals SLL.
%
% Qualitatively, the first NBAR sidelobes on any one side of the mainlobe will,
% while monotonically decreasing, have levels roughly close to each other.
% Subsequent sidelobe levels drop off more drastically.
%
% By increasing NBAR for fixed SLL, i.e., tolerating more energy in sidelobes,
% one can get a (very slightly) narrower mainlobe. Two parameterizations
% popular among synthetic aperture radar practitioners are are given in [1],
% page 512:
% 1. NBAR = 4 and SLL = -30 dB, and
% 2. NBAR = 5 and SLL = -35 dB.
%
% Numerical note. The algorithm in [1] is implemented here. It appears to have
% good numerical properties, despite using products: the 100000-point Taylor
% window with NBAR=250 and SLL=150 as implemented here has relative error of
% less than 3e-10 compared to a version that sums logs instead of direct
% products.
%
% [1] Carrara, Goodman, Majewski, *Spotlight synthetic aperture radar: signal
% processing algorithms*, Artech House, 1995. See Appendix D.2.

B = 10^(abs(sll)/20);
A = log(B + sqrt(B^2 - 1)) / pi;
sigmaSquared = nbar^2 / (A^2 + (nbar - 0.5)^2);
assert(nbar == round(nbar), 'nbar must be integer: %g is not ok', nbar)

i = 1 : (nbar - 1);

fNumerator = @(m) (-1)^(m + 1) / 2 * prod(1 - (m^2 / sigmaSquared) ./ (A^2 + (i - 0.5).^2));
fDenominator = @(m) prod(1 - m^2 ./ rangeOmit(nbar - 1, m).^2);
F = arrayfun(@(m) fNumerator(m) / fDenominator(m), 1 : nbar - 1);

m = i;
n = (0 : N - 1)';
win = 1 + 2 * cos(2 * pi / N * (n - (N - 1) / 2) * m) * F(:);
% The above uses matrix-vector multiplication:
% n is N by 1 column vector,
% m is 1 by (NBAR-1) row vector, so
% n*m is N by (NBAR-1) matrix. Therefore, cos(...) is also N by (NBAR-1).
% F(:) is (NBAR-1) by 1 column vector, so
% cos(...) * F(:) is N by 1 column vector.
% Scale and shift that column vector to get the final window.
end

function x = rangeOmit(n, m)
% returns `1:n` but omits m. Named after Python's `range`.
x = 1 : n;
x = x(x ~= m);
end
