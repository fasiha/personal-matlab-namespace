% RESCALEC rescales the color axis dynamic range keeping the top
%
%   RESCALEC(N) changes the current plot's color axis (CAXIS) to keep the top N
%   units.
%
%   RESCALEC(..., AX) modifies axis handle AX.
%
% SYNTAX:
%
%   rescalec( N )
%   rescalec( N, ax )
%
% REQUIRED INPUTS:
%
%   N: [ 1 x 1 numeric ]
%     Dynamic range of the color axis.
%
% OPTIONAL INPUTS:
%
%   ax: [ Matlab Axis object ] default GCA
%     The axis to be rescaled.
%
% EXAMPLES:
%
%   % Plot a random image containing numbers between 0 and 1.
%   figure();
%   imagesc(rand(100));
%   colorbar();
%   % The colorbar is currently between 0 and 1. Make it only 0.1 from the top,
%   % so all pixels are close to the bottom of the colorscale.
%   rescalec(0.1);
%   % Make it 10 units from the top, so all pixels are close to the colorscale's
%   % maximum
%   rescalec(10);
%
% SEE ALSO: CAXIS
%

function rescalec(N, ax)
if nargin < 2 || isempty(ax), ax = gca(); end
caxis(ax, max(caxis(ax)) - [N, 0]);
