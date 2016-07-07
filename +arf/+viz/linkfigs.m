function [] = linkfigs(figs)
% LINKFIGS calls LINKAXES on some figures
%   LINKFIGS(FIGS) will link all axes found in figure handles FIGS
%
%   LINKFIGS() will link all axes found on all figures.

if ~exist('figs', 'var') || isempty(figs), figs = viz.getallfigs(); end
linkaxes(viz.getallaxes(figs));

end
