% INTERPFTZOOM interpolates signals via frequency-domain zero-padding
%   Y = INTERPFTZOOM(XF, N) will produce the same result as INTERPFT(XF, N) when N is a scalar: it interpolates XF column-wise to an array with N rows.
%
%   If N is a vector, this function uses Zoom-FFT (which in turn uses the chirp
%   z-transform) to calculate the subset of the full interpolation specified in
%   N.  The vector N should contain equally-spaced values in the interval [0,
%   1). To explain this, the following three are fully equivalent:
%
%   >> interpft(XF, 100)
%   >> interpftzoom(XF, 100);
%   >> interpftzoom(XF, (0 : 100 - 1) / 100);
%
%   Therefore, if you had a ten-element input vector, wanted to interpolate it
%   10x using Fourier methods, producing a 100-long vector, and then only wanted
%   the first six elements of that result, you could do this:
%
%   >> input = randn(10, 1);
%   >> test1 = interpftzoom(input, 100);
%   >> test1 = test1(1:6);
%   >> test2 = interpftzoom(input, [0 : 5] / 100);
%   >> assert(max(abs(test1 - test2) ./ abs(test1)) < eps()*1e3)
%
%   In theory, the latter should be faster because it computes one 10-point FFT
%   and three 16-point FFTs (plus some complex exponentials) while the former
%   computes one 10-point and one 100-point FFT. However, relative runtimes vary
%   and in practice one has to benchmark when interptzoom is faster than the
%   straightforward technique.
%
%   Y2 = INTERPFTZOOM(..., INCOHERENT_FLAG), for INCOHERENT_FLAG false (the
%   default), is the same as INTERPFTZOOM(...). If true, however, the output
%   will not match INTERPFT without phase-correction and magnitude-scaling. That
%   is, set INCOHERENT_FLAG to true if your application can tolerate incoherent
%   results (incorrect phase and a missing magnitude scale). This can result in
%   additional speedup. In order to convert Y2 to Y, for the case where XF is an
%   M-long vector:
%
%       Y3 = Y2 .* exp(2j * pi / N * [0 : N - 1]' * -floor(M / 2)) * (N / M);
%
%   Y3 should match Y to machine-precision. This phase correction and magnitude
%   scaling are often computationally burdensome, potentially taking 20% of the
%   entire runtime.
%
%   INTERPFTZOOM('test') runs a test suite to test correctness and performance
%   against INTERPFT.
%
%   See also: INTERPFT.
%
%   Reference:
%   - Rick Lyons, "How to Interpolate in the Time-Domain by Zero-Padding in the
%   Frequency Domain", available online at
%   http://dspguru.com/dsp/howtos/how-to-interpolate-in-time-domain-by-zero-padding-in-frequency-domain
%
%   Example benchmark, via TIMEIT, on Matlab 2015a, Mac Book Pro (Mid 2014) with
%   4-core Intel Core i7, 16 GB RAM, for input array 1024 by 2000, and N = 16 *
%   1024:
%       INTERPFT    : 1.15454 s
%       INTERPFTZOOM : 0.438553 s (2.6x faster than INTERPFT)
%       Incoherent  : 0.322633 s (3.5x faster than INTERPFT)
%
%   CAVEAT: THIS FUNCTION REQUIRES `spl.sig.ZoomFFT`!

function [y, idx] = interpftzoom(x, Ny, varargin)

if nargin == 0 || strcmp(x, 'test') || strcmp(x, 'demo')
  test();
  y = 'tests passed!';
  idx = y;
  return;
end

N = size(x, 1);

p = inputParser();
addRequired(p, 'x', @(x) validateattributes(x, {'numeric'}, {}));
addRequired(p, 'Ny', @(x) validateattributes(x, {'numeric'}, {}));
addParameter(p, 'incoherent_ok', false, @(x) validateattributes(x, {'logical'}, {'scalar'}));
addParameter(p, 'Nzeropad', N, @(x) validateattributes(x, {'numeric'}, {'scalar'}));
parse(p, x, Ny, varargin{:});
mtl.util.UnpackWorkspace(p.Results);

if (Nzeropad < N)
  error('interpftzoom:badNzeropad', 'Nzeropad=%d must be >= size(x, 1)=%d', Nzeropad, N);
end

XF = fftshift(fft(x, Nzeropad), 1);

if mod(Nzeropad, 2) == 0
  XF = [XF(1, :) / 2; XF(2:end, :); XF(1, :) / 2];
end

if numel(Ny) == 1 % evenly-spaced grid, like interpft
  idx = [0 : Ny - 1] / Ny;
  if incoherent_ok
    y = ifft(XF, Ny);
    return;
  end

  y = bsxfun(@times, ...
          ifft(XF, Ny), ...
          exp(2j * pi * idx(:) * -floor(Nzeropad / 2)) * (Ny / Nzeropad));

else % specific grid, e.g., zoom.

  idx = Ny;
  Ny = numel(idx);
  if incoherent_ok
    y = spl.sig.ZoomFFT(XF, -idx);
    return;
  end

  y = bsxfun(@times, ...
             spl.sig.ZoomFFT(XF, -idx), ...
             exp(2j * pi * idx(:) * -floor(N/2)) /  Nzeropad);

end
% The elements of this trick are:
% 1) FFTSHIFT, placing the 0 radian point in the middle of the vector, and
% 2) after IFFT, modulate to undo FFTSHIFT, putting 0 rad point back in the beginning.


end


function test()
% TEST checks INTERPFTZOOM for correctness (against INTERPFT) and speed
unittest(1024, 16*1024, 2*1024, true);

unittest(128, 256, 129);
unittest(127, 256, 129);
unittest(129, 256, 130);

unittest(128, 259, 129);
unittest(127, 259, 129);
unittest(129, 259, 130);

end

function unittest(N, Nup, Nz, print)
% Helper functions revolving around checking relative error
allcloseeps = @(dirt, gold, epsfac) all(abs(dirt(:) - gold(:)) <= abs(gold(:)) * eps(norm(gold)) * epsfac);
allclose = @(dirt, gold) allcloseeps(dirt, gold, 1e5);

% Generate a test input matrix [N by Ntrials] large, and interpolate it to [Nup
% by Ntrials].
if nargin < 1, N = 1024; end
if nargin < 2, Nup = N * 16; end
Ntrials = 20;

% Generate random complex data. Take data from the default generator to not mess
% with the global random stream.
RNG = RandStream('mt19937ar');
x = RNG.randn(N, Ntrials) + 1j * RNG.randn(N, Ntrials);

% interpft result
res1 = interpft(x, Nup, 1);

% interpftzoom result
[res2, idx] = interpftzoom(x, Nup);

% zoomed result via interpftzoom: instead of Nup, pass in an index.
Nzoom = N - 1; % arbitrary
res3zoom = interpftzoom(x, idx(1:Nzoom)); % zoom.
res3 = interpftzoom(x, idx); % full: not really "zoom"

% verify correctness
assert(allclose(res1, res2))
assert(allclose(res1(1:Nzoom, :), res3zoom))
assert(allclose(res1, res3))

% incoherent result via interpftzoom. Will have incorrect phase and missing a
% magnitude scaling, but internally consistent.
res4_incoherent = interpftzoom(x, Nup, 'incoherent_ok', true);
res5zoom_inco = interpftzoom(x, idx(1:Nzoom), 'incoherent_ok', true);

% verify incoherent result by checking magnitudes after correcting the scaling
assert(allclose(abs(res4_incoherent) * Nup / N, abs(res1)))
assert(allclose(abs(res5zoom_inco) / N, abs(res3zoom)));

% test Nzeropad
if nargin < 3, Nz = N * 2; end
zeropad = @(x, n) [x; zeros(n - size(x,1), size(x, 2))];
actual6 = interpft(zeropad(x, Nz), Nup, 1);
res6 = interpftzoom(x, Nup, 'incoherent_ok', false, 'Nzeropad', Nz);
assert(allclose(res6, actual6));

% Timings
time_interpft = timeit(@() interpft(x, Nup));
time_shift = timeit(@() interpftzoom(x, Nup));
time_shift_noncoh = timeit(@() interpftzoom(x, Nup, 'incoherent_ok', true));

if nargin < 4, print = false; end
if print
  fprintf('interpft: %g s\nshift: %g s\nnon-coherent shift: %g s\n', ...
    time_interpft, ...
    time_shift, ...
    time_shift_noncoh);
end

end
