function [f_voice, P0_m, P0_fm] = vocal_excitation()
%% Excitation wave

% saw tooth wave from Anderson and Sommerfeldt
% t - time, n - mode, f - frequency 
wave_fcn = @(t,n,f) (1/n^0.7) * (-2/(n*pi)) * (1/(-1)^n) * sin(2*pi*n*f*t);

f0_female =  200; % average female voice frequency
f0_male =    120; % average male voice frequency
t = 0:0.000001:1;
modes = 15;
freqs = linspace(0,1/(1/length(t)),length(t));
f_voice = freqs(1:(length(freqs)+1)/2);

exc_female = zeros(size(t));
exc_male = zeros(size(t));
for N = 1:modes
    exc_female = exc_female + wave_fcn(t,N,f0_female);
    exc_male = exc_male + wave_fcn(t,N,f0_male);
end
exc_female(exc_female<0) = 0;
exc_male(exc_male<0) = 0;
% the magnitudes don't really match up to what was in the paper

  
%% Frequency domain

exc_fm_t = fft(exc_female);
exc_fm_tn = exc_fm_t./max(exc_fm_t);
P0_fm = exc_fm_tn(1:(length(freqs)+1)/2);
exc_m_t = fft(exc_male);
exc_m_tn = exc_m_t/max(exc_m_t);
P0_m = exc_m_tn(1:(length(freqs)+1)/2);



end


