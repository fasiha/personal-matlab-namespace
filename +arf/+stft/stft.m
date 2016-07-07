function [stft, f, t] = stft(x, win, h, nfft, fs)
% function: [stft, t, f] = stft(x, win, h, nfft, fs)
% x - signal in the time domain
% win - window
% h - hop size
% nfft - number of FFT points
% fs - sampling frequency, Hz
%
% f - frequency vector, Hz
% t - time vector, s
% stft - STFT matrix (time across columns, freq across rows)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Short-Time Fourier Transform            %
%               with MATLAB Implementation             %
%                                                      %
% Author: M.Sc. Eng. Hristo Zhivomirov       12/21/13  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inputs must be column vectors
x = x(:);
win = win(:);

% length of the signal
xlen = length(x);

% length of window
wlen = length(win);

% form the stft matrix
rown = nfft;            % calculate the total number of rows
coln = 1+fix((xlen-wlen)/h);        % calculate the total number of columns
stft = zeros(rown, coln);           % form the stft matrix

% initialize the indexes
indx = 0;
col = 1;

% perform STFT
while indx + wlen <= xlen
    % windowing
    xw = x(indx+1:indx+wlen).*win;
    
    % FFT
    X = fft(xw, nfft);
    
    % update the stft matrix
    stft(:,col) = fftshift(X);
    
    % update the indexes
    indx = indx + h;
    col = col + 1;
end

% calculate the time and frequency vectors
t = [1:coln] / (fs/h);
f = ceil(-rown / 2 : (rown / 2 - 1))' / rown * fs; %(0:rown-1)*fs/nfft;

end
