% APPLYPAIRWISE apply a function on pairs of inputs, generate triangular matrix
%
%   ARR = APPLYPAIRWISE(FN, CEL), for a cell array CEL containing N elements,
%   generates an N by N cell array, each element of which contains the result of
%   applying the function FN on each pair of elements in CEL. FN is assumed to
%   be commutative, so only the upper-right triangle (excluding diagonal) of ARR
%   is filled. ARR(I, J) will contain FN(CEL{I}, CEL{J}) if N >= J > I >= 1, and
%   will be empty otherwise.
%
%   APPLYPAIRWISE(..., VARARGIN) will provide FN with additional arguments in
%   VARARGIN. I.e., ARR(I, J) = FN(CEL{I}, CEL{J}, VARARGIN{:}).
%
% SYNTAX:
%
%   arr = applyPairwise( fn, cel )
%   arr = applyPairwise( fn, cel, varargin )
%
% REQUIRED INPUTS:
%
%   fn: [ function handle ]
%     A function that accepts two arguments and produces one output.
%
%   cel: [ N-element cell ]
%     Cell array of all inputs to evaluate FN over, pairwise.
%
% OPTIONAL INPUTS:
%
%   varargin: [ all additional arguments ]
%     Arguments to be passed to FN
%
% OUTPUTS:
%
%   arr: [ N x N cell ]
%     The upper-right triangle of this square cell array will contain FN applied
%     to each pair in the input CEL array.
%
% EXAMPLES:
%
%   % Assuming a ccd function with signature `c = ccd(x, y, w)`:
%   makeRandomImage = @() randn(10) + 1j * randn(10);
%   images = {makeRandomImage(), makeRandomImage(), makeRandomImage()};
%   ccds = applyPairwise(@ccd, images, 3);
%   % ccds will be a 3x3 cell array, containing three pairs of CCD images: A-B,
%   % B-C, A-C.
%
% SEE ALSO: PLOTPAIRWISE
%

function [arr] = applyPairwise(fn, cel, varargin)
arr = cell(numel(cel));
for i = 1 : numel(cel)
  for j = i + 1 : numel(cel)
    arr{i, j} = fn(cel{i}, cel{j}, varargin{:});
  end
end

end
