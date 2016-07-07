% PLOTPAIRWISE plots the return value of APPLYPAIRWISE
%
%   PLOTPAIRWISE(C) requires a cell array C produced by APPLYPAIRWISE. For a C
%   with size N by N, it will create an N-1 by N-1 triangle of subplots in the
%   current figure, and attempt to populate each subplot with an element in the
%   upper-triangle of C (excluding the diagonal). IMAGESC is the default
%   plotting.
%
%   PLOTPAIRWISE(..., PLOTTER) uses the function handle PLOTTER instead of
%   IMAGESC.
%
%   PLOTPAIRWISE(..., TITLES) for a cell of strings TITLES to provide titles
%   for each element of C. Each created subplot will be a title indicating the
%   pair of inputs used to create it.
%
%   HANDLES = PLOTTPAIRWISE(...) returns an array of axes objects (handles)
%   created.
%
% SYNTAX:
%
%   handles = plotPairwise( c )
%   handles = plotPairwise( c, plotter )
%   handles = plotPairwise( c, plotter, titles )
%
% REQUIRED INPUTS:
%
%   c: [ N x N cell array ]
%     The output of APPLYPAIRWISE, containing the pairwise application of some
%     function on N values.
%
% OPTIONAL INPUTS:
%
%   plotter: [ function handle ] default @imagesc
%     A function handle that accepts one input argument and plots it.
%
%   titles: [ N-element cell of strings ]
%     List containing the title of each individual element.
%
% OUTPUTS:
%
%   handles: [ (N*(N-1)/2) Axes objects ]
%     Vector of Matlab Axes objects (handles), one for each subplot
%
% EXAMPLES:
%
%   % Assuming a ccd function with signature `c = ccd(x, y, w)`
%   makeRandomImage = @() randn(10) + 1j * randn(10);
%   images = {makeRandomImage(), makeRandomImage(), makeRandomImage()};
%   ccds = applyPairwise(@ccd, images, 3);
%   % We now have three pairs of CCD images. Let's plot their magnitudes:
%   figure();
%   plotPairwise(ccds, @(x) imagesc(abs(x)), {'A', 'B', 'C'});
%
% SEE ALSO: APPLYPAIRWISE
%

function [handles] = plotPairwise(c, plotter, titles)
N = size(c, 1);
if ~exist('titles', 'var') || isempty(titles), titles = {}; end
if ~exist('plotter', 'var') || isempty(plotter), plotter = @imagesc; end

handles = [];

for i = 1 : N
  for j = i + 1 : N
    h = subplot(N - 1, N - 1, j-1 + (i-1) * (N-1));
    handles = [handles h];

    plotter(c{i,j});
    if length(titles) >= j && ~isempty(titles{i}) && ~isempty(titles{j})
      title(sprintf('%s-%s', titles{i}, titles{j}));
    end
  end
end

end

