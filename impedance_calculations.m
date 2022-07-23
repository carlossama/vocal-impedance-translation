function [sig, P_ff_spect, Z] = impedance_calculations(S, seg_len, f_voice, P0_m, P0_fm)
% Returns the time domain signal as well as far-feild pressure spectrum for
% a provided diaphram shape (S), voice frequency spectrum (f_voice), and
% impeadeance spectrum (Z)


%% System parameters

c = 343;    % speed of sound in air
f = 120;    % male frequency
k = 2*pi*f / c;
rho0 = 1.225;  % air density kg/m^3


%% Impedance Calculations


f = linspace(1,4000,500); % for frequency response
f = f_voice(2:end); % testing
k = 2*pi*f / c;
% load impeadance
%a = sqrt(0.0187/pi); % effective pipe diameter 
a = S(end); % effective radius of long pipe with open end to model load
Z_AR = 0.247*rho0*c*(k*a).^2 / S(end) + 1j * 0.613 * rho0 * c * (k*a).^2 / S(end);
Z_load = Z_AR;
Z_vec = zeros(length(f),length(S));

for i = 1:length(S)
    Z_layer = (rho0*c) / S(end-i+1);
    Z_in = Z_layer * ((Z_load + 1j * Z_layer * tan(k*seg_len))./ (Z_layer + 1j*Z_load.*tan(k*seg_len)));
    Z_load = Z_in;
    Z_vec(:,end-i+1) = Z_in';
end
Z = Z_in;
Z_vec = [Z_vec, Z_AR'];




%% Pressure calculations for spectrum (unity Prms)

P0 = 1;
P0 = Z_vec(:,1).*abs(P0_fm(2:end))';
dist_ff = 0.1;
% U_L = 1;
for i = 1:length(S)
   % P0 = (Z_vec(:,1)).*U_L;
    U_L = P0.* (1./(Z_vec(:,i+1).* cos(k'*seg_len) - 1j * (rho0*c/S(i)) * sin(k'*seg_len)));
    P0 = (Z_vec(:,i+1)).*U_L;
    %P0 = rho0*c / S(i) * U_L;
end
% i = i + 1;
% U_L = P0.* (1./(Z_vec(:,i).* cos(k'*seg_len) + 1i * (rho0*c/S(i)) * sin(k'*seg_len)));
U_L = U_L';


directivity = (k*a).^2./ (1 - besselj(1,2*k*a)./(k*a));
P_ff = sqrt(abs(U_L).^2.* real(Z_AR).* directivity.* rho0 * c / (4*pi*dist_ff^2));
figure(2)
cutoff = 8000; %length(P_ff);

P_ff = P_ff(1:cutoff);
f = f(1:cutoff);
plot(f,20*log10((P_ff)))
P_ff_spect = [P_ff, fliplr(conj(P_ff(2:end)))];
sig = ifft(P_ff_spect);

end




