function [] = makefigslike(modelfig, otherfigs)
% MAKEFIGSLIKE makes other figures have the same position as a given figure
%   MAKEFIGSLIKE(MODEL, OTHERS) makes figures with handles in OTHERS array have the same position as figure MODEL
%
%   MAKEFIGSLIKE(MODEL) assumes OTHERS is all open figures
%
%   MAKEFIGSLIKE() treats GCF as MODEL.
  import arf.viz.*
  if ~exist('modelfig', 'var') || isempty(modelfig), modelfig = gcf(); end
  if ~exist('otherfigs', 'var') || isempty(otherfigs), otherfigs = getallfigs(); end

  otherfigs.set('position', modelfig.get('position'));
end
