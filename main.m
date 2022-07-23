% Carlos Sama
% March, 2022
clear all; close all; clc

%% References
% Vocal tract area functions from magnetic resonance imaging
% Brad H. Story, Ingo R. Titze and Eric A. Hoffman

% Solving one-dimensional acoustic systems using the impedance translation theorem
% and equivalent circuits: A graduate level homework assignment
% Brian E. Anderson and Scott D. Sommerfeldt

%% Load the phoneme shapes

[tract_radius, vocal_len, seg_len] = phonemes();

%% Grab and plot /ʌ/ /i/ and /a/

% /ʌ/
ph_uh = tract_radius(:,6);
ph_uh(isnan(ph_uh)) = [];

% /i/
ph_ee = tract_radius(:,2);
ph_ee(isnan(ph_ee)) = [];

% /a/ 
ph_ah = tract_radius(:,7);
ph_ah(isnan(ph_ah)) = [];

figure(1)

subplot(3,1,1)
hold on
plot(vocal_len(1:length(ph_uh)),ph_uh,'k')
plot(vocal_len(1:length(ph_uh)),-ph_uh,'k')
title('/ʌ/ phoneme')

subplot(3,1,2)
hold on
plot(vocal_len(1:length(ph_ee)),ph_ee,'k')
plot(vocal_len(1:length(ph_ee)),-ph_ee,'k')
title('/i/ phoneme')

subplot(3,1,3)
hold on
plot(vocal_len(1:length(ph_ah)),ph_ah,'k')
plot(vocal_len(1:length(ph_ah)),-ph_ah,'k')
title('/a/ phoneme')
xlabel('position (m)')


%% Select the phoneme to simulate

S = ph_ah.^2 * pi;


%% Generate an artificial vocal chord excitation and plot the spectrum

[f_voice, P0_m, P0_fm] = vocal_excitation();

figure(2)
plot(f_voice,20*log10(abs(P0_m)))

figure(3)
plot(f_voice,20*log10(abs(P0_fm)))

%% Simulate the vocal chord excitation through the selected phenom tract

[sig, p_ff_spect, Z] = impedance_calculations(S, seg_len, f_voice, P0_m, P0_fm);

% plot input impeadance spectrum
figure(4)
plot(f_voice(2:end),20*log10(abs(Z)),'LineWidth',1.2)
xlabel('frequency (Hz)')
ylabel('Impeadance Magnitude (dB)')


%% Play the signal

sound(sig,4000)





