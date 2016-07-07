function [ax] = getallaxes(figs)
% GETALLAXES find all axes handles in figures
%   Usage: GETALLAXES(FIGS). If FIGS omitted, defaults to GCF (current figure).

if ~exist('figs', 'var') || isempty(figs), figs = gcf(); end
% See http://stackoverflow.com/a/4540637/500207
ax = findobj(figs, 'Type', 'axes', 'Visible', 'on');
  
end
