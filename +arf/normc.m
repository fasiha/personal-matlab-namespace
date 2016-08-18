function y = normc(x)
y = bsxfun(@rdivide, x, sqrt(sum(x.^2)));
end

