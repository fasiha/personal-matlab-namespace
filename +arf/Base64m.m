classdef Base64m
  % A Matlab wrapper for Java's Base64 encoding and decoding.
  %   This class just provides two static methods:
  %   - Base64m.enc(v), and
  %   - Base64m.dec(v_int8 [, optional_type]).
  %   See the docstring of each function for details.

  methods(Static)

    function b = enc(x)
      % Base64m.enc(x), for a 1D vector x, will return a column-vector of int8s
      % (signed 8-bit integers) containing the Base64-encoding of x's bytes.
      %
      % You may call CHAR on the output of this function to get a column-string
      % (and transpose it for a printable row-string), or just pass around the
      % column vector of int8s.
      import org.apache.commons.codec.binary.Base64;
      casted = typecast(x, 'int8');
      b = Base64.encodeBase64(casted);
    end

    function x = dec(b, type)
      % Base64m.dec(b), for a 1D vector of int8 (signed 8-bit integers) that
      % represents a Base64-encoded bytestream, will return a column vector of
      % int8s containing the Base64-decoding of that bytestream.
      %
      % Base64m.dec(b, type) will attempt to TYPECAST the decoded vector to that
      % `type` (e.g., 'double', 'int32', etc.). N.B.: TYPECAST will throw an
      % error if there's insufficient bytes to fully-reconstruct a vector of
      % that `type` (i.e., if you pass in a 3-byte `b` and ask for `type =
      % 'double'`, since doubles are 4 bytes long).
      import org.apache.commons.codec.binary.Base64;
      casted = typecast(b, 'int8');
      x = Base64.decodeBase64(casted);
      if nargin >= 2 && ~isempty(type)
        x = typecast(x, type);
      end
    end

  end
end

