function [y] = drop(x, n, dim)
% DROP drops the initial elements of a vector
%   Y = DROP(X) will return Y = X(2:end), dropping the first element.
%
%   Y = DROP(X, N) will drop the first N elements of X. N must be integer or
%   empty (defaults to 1).
%
%   Y = DROP(X, N, DIM) operates in the DIM dimension. DIM must be integer or
%   empty (defaults to 1 unless X is a row vector, in which case DIM defaults to
%   2).
%
%   Caveat emptor: if X has a large number of dimensions (as indicated by
%   NDIMS), the function may return incorrect results. See FIXME

if ~exist('n', 'var') || isempty(n), n = 1; end
if ~exist('dim', 'var') || isempty(dim)
  % if row vector, and dim unspecified, drop along horizontal dimension
  if ndims(x) == 2 && size(x, 1) == 1
    dim = 2;
  else
    dim = 1;
  end
end

if dim ~= 1
  numDims = ndims(x);
  dimIndex = 1:numDims;
  % Swap dim and 1
  dimIndex(1) = dim;
  dimIndex(dim) = 1;
  x = permute(x, dimIndex);
end

% There must be a better way to get all other dimensions of x : FIXME
y = x(n+1:end, :, :, :, :, :, :, :, :, :);
assert(ndims(y) == ndims(x)); % Assertion failure if x has more dims than : above

if dim ~= 1
  y = ipermute(y, dimIndex);
end

end
