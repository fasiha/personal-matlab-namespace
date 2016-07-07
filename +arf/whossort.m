function cellOut = whossot(w)
%WHOSSORT prints out human-readable size-sorted listing of current variables
%   WHOSSORT() prints out the variables and sizes in the current workspace
%
%   WHOSSORT(W) does the same for a custom output of WHOS, i.e., W = whos('t*').
%
%   C = WHOSSORT(...) returns a cell array containing the name, numeric size, 
%   and size units.

% If no output of `whos` is passed in, evaluate `whos` in the calling function.
if ~exist('w', 'var') || isempty(w), w = evalin('caller', 'whos'); end

% Sort the output of whos by size, descending
[~, sidx] = sort(-[w.bytes]);
w = w(sidx);

% Convert bytes to a decimal number and a units like GB or KB
[val, units] = arrayfun(@bytesToHuman, [w.bytes], 'uniformoutput', 0);

% Build the output cell array and print it if no output is requested
cellOut = cell(1, length(w));
for i=1:length(w)
  if nargout == 0
    fprintf('% 5.3g %s\t%s\n', val{i}, units{i}, w(i).name)
  end
  cellOut{i} = {w(i).name, val, units, w};
end
end

function [val units] = bytesToHuman(x)
% pow = floor( log1024( x ) ), that is, what power 1024 has to be raised to.
% The floor lets us have 900 KB, instead of 0.9 MB, which I think is more readable.
pow = floor(log2(x) / log2(1024));

% if x = 0, pow will be -Inf. Floor that to 0.
pow(~isfinite(pow)) = 0;

% Make sure the biggest pow should be 3 (GB).
pow(pow > 3) = 3;

% Pick a human-readable units.
units = '';
switch pow
case 0
  units = ' B';
case 1
  units = 'KB';
case 2
  units = 'MB';
otherwise
  units = 'GB';
end

% Scale x (# of bytes) by pow so "{x} {units}" is a human-readable size.
val = x / 1024^pow;
end

