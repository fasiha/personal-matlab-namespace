function cube = singleToRGBA(x, fname)
if ~strcmp(class(x), 'single')
  x = single(x);
end
cube = zeros(size(x,1), size(x,2), 4, 'uint8');
for j=1:size(x,2)
  for i=1:size(x, 1)
    cube(i,j,:) = typecast(x(i,j), 'uint8');
  end
end

if exist('fname', 'var') && ~isempty(fname)
  rgbaToPng(cube, fname);
end

