function [cropped, idxs] = autocrop(in, predicate)
%autocrop crops edge rows/columns of 2D array that fail to meet predicate.
%
% Usage:
% - [cropped] = autocrop(x, predicate)
% - [cropped, i] = autocrop(x, predicate).
% where x is some 2D array, and predicate is a function handle that accepts a
% single array argument and returns a boolean array of the same size, true for
% pixels you wish to keep (not crop) and false for pixels you wish to discard
% (crop). cropped is the cropped sub-array of x (same size or smaller than x,
% potentially empty). i is a vector of indexes, where cropped is
% x(i(1) : i(2), i(3) : i(4))
%
% Example: pad an array with bands of zeros around it (that's what BLKDIAG
% does), then recover the original array.
%
% >> good = [1 2; 3 0];
% >> bad = blkdiag(zeros(2,3), good, zeros(3,4));
% >> goodAgain = autocrop(bad, @(x) x ~= 0);
% >> assert(all(goodAgain(:) == good(:)))
%
% To recover the cropped sub-array using the second return value (vector i):
%
% >> [~, i] = autocrop(bad, @(x) x ~= 0);
% >> goodAgain2 = bad(i(1) : i(2), i(3) : i(4));
% >> assert(all(good(:) == goodAgain2(:)))
%
% Implementation based on Jan Simon's, on 18 Apr 2013:
% http://www.mathworks.com/matlabcentral/answers/72536-crop-part-of-an-image#answer_82647

bool = predicate(in);
[i1, i2] = find(bool);

idxs = [min(i1) max(i1) min(i2) max(i2)];
if isempty(idxs)
  cropped = in;
else
  cropped = in(idxs(1) : idxs(2), idxs(3) : idxs(4)); 
end
