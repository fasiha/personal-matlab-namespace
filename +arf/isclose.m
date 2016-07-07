function [ret] = isclose(dirt, gold, rtol, atol)
% ISCLOSE checks if two inputs are numerically close
%   ISCLOSE(DIRT, GOLD, RTOL, ATOL) returns the element-wise comparison:
%       abs(DIRT - GOLD) <= (ATOL + RTOL * abs(GOLD))
%   where ATOL (defaults to 1e-5 if omitted) is the absolute tolerance and RTOL
%   is the relative tolerance (defaults to 1e-8 if omitted).
%
%   A partial port of `numpy.isclose` [1]. Does not handle NaN, Inf, etc.
%
% [1] http://docs.scipy.org/doc/numpy-dev/reference/generated/numpy.isclose.html

if ~exist('rtol', 'var') || isempty(rtol), rtol = 1e-5; end
if ~exist('atol', 'var') || isempty(atol), atol = 1e-8; end

ret = abs(dirt - gold) <= (atol + rtol * abs(gold));

end
