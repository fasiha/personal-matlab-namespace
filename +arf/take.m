function [ret] = take(x, n)
% TAKE returns first N entries of an array
%   TAKE(X, N) returns X(1:N)
ret = x(1:min(n, numel(x)));
end
