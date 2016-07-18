function [b, a] = pybutter(norder, cutoff)
numpy = py.scipy.signal.butter(int32(norder), cutoff);
res = cellfun(@(x) cell2mat(x.tolist.cell), numpy.cell, 'un', 0);
b = res{1};
a = res{2};



