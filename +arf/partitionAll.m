function y = partitionAll(x, sizes)
%`partitionAll` Chunks an array into N-dimensional sub-arrays
%
%  `c = partitionAll(x, sizes)` for some N-dimensional array `x` and a vector of
%  chunk sizes `sizes` (nominally `numel(sizes) == ndims(x)`) returns `c`, an
%  N-dimensional cell array whose entries contain sub-arrays of `x` such that,
%  each sub-array in c has size nominally equal to `sizes` (i.e., `size(c{i,
%  j})` is nominally equal to `sizes`).
%
%  E.g., `partitionAll(randn(4, 4), [2 2])` returns a 2 by 2 cell array, each
%  element of which contains a 2 by 2 sub-block of the original 4 by 4 input.
%
%  In the case where a requested chunk size does not evenly divide `x` along the
%  given dimension, the final set of sub-arrays will have size less than the
%  requested chunk size.
%
%  E.g., `partitionAll(randn(4, 4), [3 3])` will return a 2 by 2 cell array
%  whose elements have the following sizes:
%   { 3x3 3x1
%     1x3 1x1 }
%
%  `sizes` with fewer elements than `ndims(x)` are padded with the actual
%  dimensions of `x`. So, `partitionAll(rand(4, 4), 2)` will chop the original
%  array in two, top and bottom: the returned 2 by 1 cell array has elements
%  with size 2 by 4.
%
%  `sizes` with more elements than `ndims(x)` have the extra elements ignored.
%
%  `sizes` are capped at the size of `x` along each dimension, so `inf` may be
%  used to indicate chunk sizes of "as large as possible".
%
%  E.g., `partitionAll(randn(4, 4), [inf 3])` returns a 4 by 3 sub-array and a 4
%  by 1 vector in the returned cell array.

if numel(sizes) > ndims(x)
  % trim `sizes`
  sizes = sizes(1:ndims(x));
elseif numel(sizes) < ndims(x)
  % pad `sizes` with sizes of dimensions
  fixed = size(x);
  fixed(1:numel(sizes)) = sizes;
  sizes = fixed;
end
% make sure `sizes` doesn't contain elements > size of that dimension
sizes = min(sizes, size(x));
% make sure `sizes` doesn't contain <= 0
sizes = max(sizes, 1);

% ready to roll. Generate input for `mat2cell`.

onesLike = @(x) ones(size(x));
sizesCell = num2cell(sizes);

for i = 1 : numel(sizesCell)
  chunkSize = sizes(i);
  maxSize = size(x, i);
  rep = onesLike(1:chunkSize:maxSize) * chunkSize;
  if sum(rep) > maxSize
    rep(end) = maxSize - sum(rep(1:end-1));
  end
  sizesCell{i} = rep;
end

% finally call `mat2cell`

y = mat2cell(x, sizesCell{:});
