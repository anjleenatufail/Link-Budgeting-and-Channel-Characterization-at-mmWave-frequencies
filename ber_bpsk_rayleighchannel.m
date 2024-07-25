%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All rights reserved by Krishna Pillai, http://www.dsplog.com
% The file may not be re-distributed without explicit authorization
% from Krishna Pillai.
% Checked for proper operation with Octave Version 3.0.0
% Author        : Krishna Pillai
% Email         : krishna@dsplog.com
% Version       : 1.0
% Date          : 8 August 2008
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script for computing the BER for BPSK modulation in a
% Rayleigh fading channel

clear
N = 10^4 % number of bits or symbols

% Transmitter
ip = rand(1,N)>0.5; % generating 0,1 with equal probability
s = 2*ip-1; % BPSK modulation 0 -> -1; 1 -> 0 

 
Eb_N0_dB = [-3:50]; % multiple Eb/N0 values
load("hmatrixfile.mat");
[r,c]=size(hf_freq);
for i=1:c
  A=[real(hf_freq(1,i)),imag(hf_freq(1,i))];
    resultant(i)=sqrt(A(1,1)^2 + A(1,2)^2);
end
h_normalized=resultant/(sqrt(var(resultant)));
h=10*log10(h_normalized);
for ii = 1:length(Eb_N0_dB)
   
   n = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % white gaussian noise, 0dB variance 
   hprog = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % Rayleigh channel
   
   % Channel and noise Noise addition
   y = h.*s + 10^(-Eb_N0_dB(ii)/20)*n; 

   % equalization
   yHat = y./h;

   % receiver - hard decision decoding
   ipHat = real(yHat)>0;

   % counting the errors
   nErr(ii) = size(find([ip- ipHat]),2);

end

simBer = nErr/N; % simulated ber
theoryBerAWGN = 0.5*erfc(sqrt(10.^(Eb_N0_dB/10))); % theoretical ber
EbN0Lin = 10.^(Eb_N0_dB/10);
theoryBer = 0.5.*(1-sqrt(EbN0Lin./(EbN0Lin+1)));

% plot
close all
figure
semilogy(Eb_N0_dB,theoryBerAWGN,'cd-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,theoryBer,'bp-','LineWidth',2);
semilogy(Eb_N0_dB,simBer,'mx-','LineWidth',2);
axis([-3 50 10^-5 0.5])
grid on
legend('AWGN-Theory','Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK modulation in Rayleigh channel');