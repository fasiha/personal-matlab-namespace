function [ret] = allclose(varargin)
% ALLCLOSE ensures all elements of two arrays are close, via `isclose`
ret = all(isclose(varargin{:}));
end
