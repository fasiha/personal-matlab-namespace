function [varargout] = arrayfun0(varargin)
% ARRAYFUN0 is a wrapper for ARRAYFUN that automatically allows non-uniform outptus
%   ... = ARRAYFUN0(...) is equivalent to ... = ARRAYFUN(..., 'UniformOutput', 0),
%   which allows a function to return non-scalar values. Variable-length outputs
%   are supported, just like ARRAYFUN.
%
%   If ARRAYFUN0 is invoked with 'UniformOutput' as one if its arguments, then
%   that will be respected: ARRAYFUN0 will *not* append anything to its
%   invocation of ARRAYFUN.

varargout = cell(1, max(1, nargout));

% If 'UniformOutput' is in varargin, just pass everything to arrayfun. From
% experimentation, I see that if arrayfun is invoked with two 'UniformOutput'
% parameters, the first takes precedence, but I don't want to rely on that
% always being true (it might change if inputParser is modified, e.g.).
if any(arrayfun(@(x) ischar(x) && strcmpi(x, 'uniformoutput'), varargin))
  [varargout{:}] = arrayfun(varargin{:});
else
  [varargout{:}] = arrayfun(varargin{:}, 'UniformOutput', 0);
end

end

