function [ret] = flatten(cel)
% FLATTEN flattens a cell of cells by one level
ret = functional.foldl(cel, {}, @(memo, curr) cat(2, memo, curr));
end
