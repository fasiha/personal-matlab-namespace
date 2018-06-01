function writebin(arr, fname)
fid = fopen(fname, 'wb');
assert(fid > 0);
if isreal(arr)
  fwrite(fid, arr(:), class(arr));
else
  interleaved = [real(arr(:)).'; imag(arr(:)).'];
  interleaved = interleaved(:);
  fwrite(fid, interleaved, class(arr));
end
fclose(fid);

