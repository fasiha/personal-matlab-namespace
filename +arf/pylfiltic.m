function z = pylfiltic(b, a)
if nargin == 0
  demo()
  z = []; return;
end
numpy = py.scipy.signal.lfiltic(b, a, zeros(1, max(numel(b), numel(a))));
z = cell2mat(numpy.tolist.cell);
end

function demo()
import arf.pycheby2 arf.pylfiltic;
RNG = RandStream('mt19937ar', 'Seed', 1234);
x1 = RNG.randn(100,1);
x2 = RNG.randn(100,1);
x = [x1; x2];

[b, a] = pycheby2(8, 40, .5);

y = filter(b, a, x);

z = pylfiltic(b, a);
[y1, z] = filter(b, a, x1, z);
[y2, z] = filter(b, a, x2, z);

ytest = [y1; y2];

assert(max(abs(ytest - y) ./ abs(y)) < eps() * 1e3);

disp('Unit test passed!');
end

