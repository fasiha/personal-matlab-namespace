function [y] = db20invert(x)
%DB20 convert values from decibels back to non-log: 10^(x / 20).
y = 10.^(x / 20);
