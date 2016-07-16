function res = pyfiltfilt2(b, a, x, dim)
import arf.pyfiltfilt2;

if nargin == 0
  demo()
  disp('Test passed!');
  res = [];
  return;
end

if any(imag(x(:)))
  re = pyfiltfilt2(b, a, real(x), dim);
  im = pyfiltfilt2(b, a, imag(x), dim);
  res = complex(re, im);
  return;
end

RNG = RandStream('mt19937ar','Seed','shuffle');
fname = ['tmp-' sprintf('%d', feature('getpid')) '-' arf.shuffle(char([RNG.randi([97 122], 1,5) RNG.randi([65,90],1,5) RNG.randi([48 57],1,5)])) '.bin'];

fid = fopen(fname, 'wb');
assert(fid>0);
fwrite(fid, x(:), class(x));
fclose(fid);

xpy = py.numpy.fromfile(fname, class(x)).reshape(int32(fliplr(size(x)))).T;
ypy = py.scipy.signal.filtfilt(b, a, xpy, int32(dim - 1));
ypy.T.ravel().astype(class(x)).tofile(fname);

fid = fopen(fname, 'rb');
assert(fid>0);
res = cast(fread(fid, inf, class(x)), 'like', x);
fclose(fid);

res = reshape(res, size(x));

end


function demo()
  import arf.pyfiltfilt2 arf.pyfiltfilt arf.pycheby2;

  [b, a] = pycheby2(3, 20, .5);
  x = randn(2, 13) + 1j * randn(2, 13);
  y = pyfiltfilt(b, a, x, 2);
  yTest = pyfiltfilt2(b, a, x, 2);
  assert(all(yTest(:) == y(:)))

  y2 = pyfiltfilt(b, a, single(x), 2);
  y2Test = pyfiltfilt2(b, a, single(x), 2);
  assert(all(yTest(:) == y(:)))
  assert(max(abs(y2(:) - y2Test(:)) ./ abs(y2(:))) < eps(single(1))*1e2)


end

