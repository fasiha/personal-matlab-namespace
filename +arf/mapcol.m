function [y] = mapcol(fn, arr)
% MAPCOL applies a function to each column of an array
%   Y = MAPCOL(FN, ARR) produces an array Y has the same number of columns as
%   array ARR, and Y(:, I) = FN(ARR(:, I)). 
  
y = cell2mat(arrayfun(@(i) fn(arr(:,i)), 1:size(arr, 2), 'uniformoutput', 0));
end
