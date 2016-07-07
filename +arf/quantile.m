function [val] = quantile(x, p)
  assert(all(p <= 1 & p >= 0));
  x = sort(x);
  idx = round(numel(x) * p);
  idx = min(max(idx, 1), numel(x));
  val = x(idx);
end
