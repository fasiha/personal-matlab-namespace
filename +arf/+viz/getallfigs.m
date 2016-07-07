function [figs] = getallfigs()
% GETALLFIGS returns a list of all open figures
figs = findobj('Type','figure');
end
