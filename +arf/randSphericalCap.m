function r = randSphericalCap(coneAngleDegree, coneDir, N, RNG)
%RANDSPHERICALCAP samples points on a directional cap of the unit sphere
%
%  Usage:
%  `r = randSphericalCap(degrees)` returns a 3 by 1 unit-vector `r` that is
%  randomly generated but guaranteed to be within `degrees` degrees of North
%  Pole vector `[0; 0; 1]`, in terms of the standard cosine similarity. In other
%  words, for
%  >> theta = acos(r' * [0;0;1])
%  `theta * 180/pi` is guaranteed to be <=`degrees`.
%
%  `randSphericalCap(degrees, direction)` reorients the spherical cap in
%  `direction` (a 3 by 1 vector) direction. If missing or empty, the default is
%  the North Pole vector `[0; 0; 1]`.
%
%  `randSphericalCap(degrees, direction, N)` returns a 3 by `N` array, the
%  columns of which are random samples from the directed spherical cap. If
%  missing or empty, `N = 1` is default.
%
%  `randSphericalCap(degrees, direction, N, RNG)` will use `RNG` as the
%  RANDSTREAM random number generator instead of the current Matlab global one.
%  Use this for repeatable results. E.g.,
%  >> RNG1 = RandStream('mt19937ar', 'Seed', 123);
%  >> r1 = randSphericalCap(10, [], 100, RNG1);
%  >> RNG2 = RandStream('mt19937ar', 'Seed', 123);
%  >> r2 = randSphericalCap(10, [], 100, RNG2); % 2 instead of 1
%  >> assert(all(r1 == r2));
%  In words, calls to `randSphericalCap` with re-generated random streams will
%  result in identical results. If omitted or empty, the current Matlab global
%  random stream is used.
%
%  Uses the algorithm described by joriki in [1], as well as the axis-angle to
%  rotation matrix formulation in [2].
%
%  N.B. A histogram of cosine similarities between `direction` and the random samples
%  generated are, when normalized by the surface area of the spherical segment
%  between bin edges, will be nominally-uniform. That is, a histogram's bin
%  edges, in degrees from 0 to `degrees`, describe a sequence of spherical
%  caps, so dividing the histogram frequencies by the surface area of the
%  spherical segments (the intersection of two spherical caps, one larger than
%  the other) described by each pair of bin edges gives us "normalized
%  frequency", or "number of random samples per unit area". This "normalized
%  histogram" will be nominally uniform. The surface area of a spherical cap, of
%  radius `R` and angle `theta` is `2 * pi * R^2 * (1 - cos(theta))`, from [3].
%  So, sample 100,000 points from the 120 degree spherical cap around the North
%  Pole, find resulting vectors' cosine similarity against the North Pole
%  vector `[0;0;1]`, and compute their 16-bin histogram. This yields 16
%  frequencies and 17 bin edges (of angle). Compute the surface area of the 16
%  spherical segments described by those 17 bin edges, where the surface area of
%  the segment between `edges(1)` and `edges(2)` is `diff(2*pi*(1-cos(edges)))`
%  if `edges` is in radians. Normalize the histogram frequencies by these 16
%  surface areas of the 16 spherical segments and plot them. These will seem
%  uniformly-distributed, whereas the original cosine similarities will be
%  heavily skewed away from 0 degrees.
%  >> u = [0; 0; 1];
%  >> r = randSphericalCap(120, u, 1e5);
%  >> angles = acos(u' * r) * 180/pi;
%  >> [n, edges] = histcounts(angles, 16);
%  >> surfaceAreas = diff(2 * pi * (1 - cos(edges * pi/180)));
%  >> figure();
%  >> plot(edges(1:end-1), n, 'bo', edges(1:end-1), n ./ surfaceAreas, 'rx')
%  >> legend('original', 'normalized');
%  >> title('Histogram and normalized histogram of cosine similarities')
%
%  To visualize some of the samples:
%  >> figure();
%  >> scatter3(r(1,1:1e4), r(2,1:1e4), r(3,1:1e4))
%
%  [1] http://math.stackexchange.com/a/205589/81266
%  [2] https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle
%  [3] http://mathworld.wolfram.com/SphericalCap.html
if ~exist('coneDir', 'var') || isempty(coneDir)
  coneDir = [0;0;1];
end

if ~exist('N', 'var') || isempty(N)
  N = 1;
end

if ~exist('RNG', 'var') || isempty(RNG)
  RNG = RandStream.getGlobalStream();
end

coneAngle = coneAngleDegree * pi/180;

% Generate points on the spherical cap around the north pole [1].
% [1] See http://math.stackexchange.com/a/205589/81266
z = RNG.rand(1, N) * (1 - cos(coneAngle)) + cos(coneAngle);
phi = RNG.rand(1, N) * 2 * pi;
x = sqrt(1-z.^2).*cos(phi);
y = sqrt(1-z.^2).*sin(phi);

% If the spherical cap is centered around the north pole, we're done.
if all(coneDir(:) == [0;0;1])
  r = [x; y; z];
  return;
end

% Find the rotation axis `u` and rotation angle `rot` [1]
u = normc(cross([0;0;1], normc(coneDir)));
rot = acos(dot(normc(coneDir), [0;0;1]));

% Convert rotation axis and angle to 3x3 rotation matrix [2]
% [2] See https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle
crossMatrix = @(x,y,z) [0 -z y; z 0 -x; -y x 0];
R = cos(rot) * eye(3) + sin(rot) * crossMatrix(u(1), u(2), u(3)) + (1-cos(rot))*(u * u');

% Rotate [x; y; z] from north pole to `coneDir`.
r = R * [x; y; z];

end

function y = normc(x)
y = bsxfun(@rdivide, x, sqrt(sum(x.^2)));
end

