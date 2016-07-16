function [w, h] = freqz(b, a)
numpy = py.scipy.signal.freqz(b, a);
res = cellfun(@(x) cell2mat(x.tolist.cell), numpy.cell, 'un', 0);
w = res{1};
h = res{2};

