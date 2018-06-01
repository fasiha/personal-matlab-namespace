function x = readbin(filename, precision, ascomplex)
  if ~exist('ascomplex', 'var') || isempty(ascomplex)
    ascomplex = false;
  end

  fid = fopen(filename, 'rb');
  if fid <= 0
    error('readbin:fileNotFound', '%s not found', filename);
  end
  
  x = fread(fid, inf, ['*' precision]);
  fclose(fid);

  if ascomplex
    isodd = mod(length(x), 2);
    x = complex(x(1 : 2 : end - isodd), x(2 : 2 : end - isodd));
  end
end

