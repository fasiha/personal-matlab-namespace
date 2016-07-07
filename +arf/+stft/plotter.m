function [hand] = plotter(varargin)
% PLOTTER generates a STFT and plots it
[s,f,t]=stft.stft(varargin{:});

hand = imagesc(t * 1e6, f / 1e6, db20(s));
axis xy
xlabel('time (us)')
ylabel('freq (MHz)')
end
