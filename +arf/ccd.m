% CCD calculates the coherent change difference (CCD) between two images
%
%   C = CCD(X, Y, W) calculates the coherent change between two potentially
%   complex-valued images x and y, using a window size W. In statistics terms,
%   it evaluates the non-central Pearson correlation coefficient between two
%   images over a local, sliding window:
%
%   $c = \frac{\sum_i x_i y_i^*}{\sqrt{[\sum_i x_i x_i^*] [\sum_i y_i y_i^*]}}$
%
%   where $x$ and $y$ are W by W subsets of the input images X and Y, and the
%   index $i$ runs over W^2 pixels.
%
%   The two input images X and Y should be the same size, and the output
%   change-detected image C will be the same size as inputs.
%
%   The pixels of output C will be complex-valued if the inputs X and Y are
%   complex. In that case, C's pixels' magnitudes will be between 0 and 1, the
%   former implying a complete change (total incoherence between images), and
%   the latter implying no change (full coherence).
%
% SYNTAX:
%
%   coef = ccd( x, y, w )
%
% REQUIRED INPUTS:
%
%   x: [ N x M complex ]
%     First image.
%
%   y: [ N x M complex ]
%     Second image.
%
%   w: [ 1 x 1 integer ]
%     The length of a side of the square-shaped sliding window to use. Typically
%     odd (3, 5, ...) so that an output pixel contains the contributions of
%     input pixels symmetrically about it.
%
% OUTPUTS:
%
%   c: [ N x M complex ]
%     The change-detected image.
%
% REFERENCES:
%
%   M. Preiss, N.J.S. Stacy, "Coherent change detection: theoretical description
%   and experimental results," Australian Government DSTO, Technical Report
%   DSTO-TR-1851, 2006.
%   http://dspace.dsto.defence.gov.au/dspace/handle/1947/4410. See equation
%   (67).
%

function coef = ccd(x, y, winsize)
win = ones(winsize) / winsize^2;

num = filter2(win, x .* conj(y));
den = sqrt(filter2(win, abs(x).^2) .* filter2(win, abs(y).^2));

coef = num ./ den;
