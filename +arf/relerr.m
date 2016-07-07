function o = relerr(dirt, gold)
o = abs((dirt(:)-gold(:)) ./ gold(:));
