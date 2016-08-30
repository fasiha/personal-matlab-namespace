function [stftArr, fVec, tVec] = stft(data, window, varargin)
%STFT performs the short-time Fourier transform: a poor person's spectrogram
%
%  [S, F, T] = STFT(X, WINDOW) returns the short-time Fourier transform of data
%  X (treated as a single rasterized vector) over chunks of X specified by
%  WINDOW. WINDOW may be a scalar integer, which implies a rectangular window of
%  WINDOW samples. Or WINDOW may be a vector, whose length specifies the chunk
%  size of X to take the STFT over, and which will multiply those chunks of X:
%  this is how one may use a taper window such as a Hamming or Kaiser window.
%
%  S is a Nf by Nf complex array, such that the Nth column contains the spectrum
%  of the Nth WINDOW-sized chunk of X.
%
%  F is an Nf by 1 vector of frequencies, in Hz, one for each row of S. When X
%  is complex (has non-zero imaginary components), F runs from -0.5 (inclusive)
%  to +0.5 (not inclusive): the spectra in S have 0 in the middle.  When X has
%  no imaginary component, or in one-sided mode (see below), F runs from 0
%  (inclusive) to +0.5 (exclusive).
%
%  T is a 1 by Nt vector of times in seconds that correspond to the start times
%  of each WINDOW-sized chunk of X, and to the columns of S.
%
%  STFT(..., 'noverlap', NOVERLAP) for integer NOVERLAP specifies the number of
%  samples of overlap desired between chunks. 0 <= NOVERLAP < window size. By
%  default, this is half the window size.
%
%  STFT(..., 'nfft', NFFT) for integer NFFT >= window length will
%  generate NFFT-long spectrograms. Defaults to the power-of-two >= window
%  length.
%
%  STFT(..., 'fs', FS) specifies X's sample rate FS in samples per second (Hz).
%  F will then run from -FS/2 (two-sided) or 0 (one-sided), inclusive in either
%  case, to FS/2 (not inclusive).
%
%  STFT(..., 'twosided', TWOSIDED) requires boolean TWOSIDED. If X is complex,
%  this must be TRUE (otherwise error). If X is all-real, then by default this
%  is FALSE but may be overridden to TRUE. When FALSE (one-sided), only positive
%  frequencies are returned in F and the STFT (N.B.: alas this does not profer
%  any computational savings: the one-sided STFT still computes the full
%  two-sided STFT and just throws away negative frequencies).
%
%  If called without any output arguments, a new figure will be opened and the
%  STFT will be plotted, in decibels (20 * log10(|S|)).

  %% Ensure window is a vector
  if numel(window) == 1
    window = ones(window, 1);
  end

  %% Parse optional arguments
  params = inputParser();
  addParameter(params, ...
               'noverlap', ...
               round(numel(window) / 2), ...
               @(x) validateattributes(x, ...
                                       {'numeric'}, ...
                                       {'scalar', 'nonnegative', 'integer'}));
  addParameter(params, ...
               'nfft', ...
               2^nextpow2(numel(window)), ...
               @(x) validateattributes(x, ...
                                       {'numeric'}, ...
                                       {'scalar', 'nonnegative', 'integer'}));
  addParameter(params, ...
               'fs', ...
               1, ...
               @(x) validateattributes(x, ...
                                       {'numeric'}, ...
                                       {'scalar', 'positive'}));
  addParameter(params, ...
               'twosided', ...
               any(imag(data(:)) ~= 0), ...
               @(x) validateattributes(x, ...
                                       {'logical'}, ...
                                       {'scalar'}));
  parse(params, varargin{:});

  noverlap = params.Results.noverlap;
  nfft = params.Results.nfft;
  fs = params.Results.fs;
  twosided = params.Results.twosided;

  %% Check all requirements
  assert(numel(window) <= numel(data), ...
         'Required: window length (%d) <= data length (%d)', ...
         numel(window), ...
         numel(data))
  assert(noverlap >= 0 & noverlap < numel(window), ...
         'Required: 0 <= overlap samples (%d) < window length (%d)', ...
         noverlap, ...
         numel(window));
  assert(nfft >= numel(window), ...
         'Required: nfft >= window length (%d not >= %d)', ...
         nfft, ...
         numel(window));
  if ~twosided
    assert(all(imag(data(:)) == 0), ...
           'twosided=false requires purely real input');
  end

  %% Generate STFT data
  stftArr = cell2mat(arf.partition(data(:), ...
                                   numel(window), ...
                                   noverlap, ...
                                   @(x) x .* window / numel(window), ...
                                   true)');
  stftArr = fftshift(fft(stftArr, nfft), 1);

  %% Generate time and frequency vectors
  [Nf, Nt] = size(stftArr);

  fVec = ceil([0 : Nf - 1] - Nf/2)' / Nf * fs;

  hop = numel(window) - noverlap;
  tVec = [0 : Nt - 1] / fs * hop;

  %% Remove negative frequencies if necessary
  if ~twosided
    realIdx = fVec >= 0;
    fVec = fVec(realIdx);
    stftArr = real(stftArr(realIdx, :));
  end

  %% Plot if no output arguments requested
  if nargout == 0
    figure();
    imagesc(tVec, fVec, 20 * log10(abs(stftArr)))
    xlabel('time (seconds)');
    ylabel('frequency (Hz)');
    colorbar
    axis xy
  end
end
