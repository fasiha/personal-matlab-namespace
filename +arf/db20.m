% DB20 converts linear valeus to decibels: 20 log_{10} |x|
%
% SYNTAX:
%
%   y = db20( x )
%
% REQUIRED INPUTS:
%
%   x: [ numeric ]
%     Input linear value
%
% OUTPUTS:
%
%   y: [ numeric ]
%     The input in dB: 20 * log10(abs(x))
%
% EXAMPLES:
%
%   x = db20([100, 200]);
%   % x(2) will be approximately x(1) + 6.02.
%

function [y] = db20(x)
y = 20 * log10(abs(x));
