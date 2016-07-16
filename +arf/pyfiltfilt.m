function res = pyfiltfilt(b, a, x, dim)
import arf.pyfiltfilt;

if any(imag(x(:)))
  re = pyfiltfilt(b, a, real(x), dim);
  im = pyfiltfilt(b, a, imag(x), dim);
  res = complex(re, im);
  return;
end

xpy = py.numpy.array(x(:).');
xpy = xpy.reshape(int32(fliplr(size(x)))).T;

numpy = py.scipy.signal.filtfilt(b, a, xpy, int32(dim - 1));
c = cellfun(@(l) cell2mat(l.cell), numpy.tolist.cell, 'un', 0);
res = cat(1, c{:});

end


