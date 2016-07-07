function [varargout] = cellfun0(varargin)
% CELLFUN0 is a wrapper for CELLFUN that automatically allows non-uniform outptus
%   ... = CELLFUN0(...) is equivalent to ... = CELLFUN(..., 'UniformOutput', 0),
%   which allows a function to return non-scalar values. Variable-length outputs
%   are supported, just like CELLFUN.
%
%   If CELLFUN0 is invoked with 'UniformOutput' as one if its arguments, then
%   that will be respected: CELLFUN0 will *not* append anything to its
%   invocation of CELLFUN.

varargout = cell(1, max(1, nargout));

% If 'UniformOutput' is in varargin, just pass everything to cellfun. From
% experimentation, I see that if cellfun is invoked with two 'UniformOutput'
% parameters, the first takes precedence, but I don't want to rely on that
% always being true (it might change if inputParser is modified, e.g.).
if any(cellfun(@(x) ischar(x) && strcmpi(x, 'uniformoutput'), varargin))
  [varargout{:}] = cellfun(varargin{:});
else
  [varargout{:}] = cellfun(varargin{:}, 'UniformOutput', 0);
end

end
