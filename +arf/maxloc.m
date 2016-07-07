function [loc, val] = maxloc(varargin)
% MAXLOC flips the order of returns as MAX
%   [LOC, VAL] = MAXLOC(...) when [VAL, LOC] = MAX(...).
[val, loc] = max(varargin{:});
end
