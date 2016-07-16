function taps = pyfirwin(ntaps, cutoff)
numpy = py.scipy.signal.firwin(int32(ntaps), cutoff);
taps = cell2mat(numpy.tolist.cell);

