function [] = linkfigs(figs)
% LINKFIGS calls LINKAXES on some figures
%   LINKFIGS(FIGS) will link all axes found in figure handles FIGS
%
%   LINKFIGS() will link all axes found on all figures.

import arf.viz.*;
if ~exist('figs', 'var') || isempty(figs), figs = getallfigs(); end
linkaxes(getallaxes(figs));

end
