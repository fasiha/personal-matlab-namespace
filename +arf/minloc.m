function [loc, val] = minloc(varargin)
% MINLOC flips the order of returns as MIN
%   [LOC, VAL] = MINLOC(...) when [VAL, LOC] = MIN(...).
[val, loc] = min(varargin{:});
end
