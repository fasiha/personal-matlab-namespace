function [b, a] = pycheby2(norder, stopbandRipple, cutoff)
numpy = py.scipy.signal.cheby2(int32(norder), stopbandRipple, cutoff);
res = cellfun(@(x) cell2mat(x.tolist.cell), numpy.cell, 'un', 0);
b = res{1};
a = res{2};

