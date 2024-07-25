clc
clear all; close all;
% loading the hmatrix file and phase data file
load('hmatrixfile.mat');
load('phase_dis.mat')
% plotting the histogram of phase data
%figure(1);
h = histogram(phase_dis,50);
p = histcounts(phase_dis,50,'Normalization','pdf');
% plotting the pdf of phase
figure(2);
binCenters = h.BinEdges + (h.BinWidth/2);
stem(binCenters(1:end-1), p, 'r-')
xlabel('phase in radians from 0 to 2pi(6.28)');
ylabel('probability');
title('pdf of phase');
% measuring size of h matrix
[r,c]=size(hf_freq);
for i=1:c
    A=[real(hf_freq(1,i)),imag(hf_freq(1,i))];
    % for finding resultant of each complex CIR
    resultant(i)=sqrt(A(1,1)^2 + A(1,2)^2);
end
% normalizing the resultant data
h_normalized=resultant/(sqrt(var(resultant)));
% plotting normalized values histogram
figure(3);
histogram(h_normalized);
xlabel('normalized resultant values(h_normalized)');
ylabel('number of occurence');
title('histogram for generated channel model');
[count1, xvlaues]=hist(h_normalized,1000);
% plotting proof of randomness in channel
figure(4);
plot(10*log10(h_normalized(1:100)));
xlabel('instantaneuos time');
ylabel('normalised amplitude of channel output');
title('randomness in channel from one time instant to other');
cir=10*log10(h_normalized);
% plotting the histogram first for finding pdf of normalized resultant data
%figure(5);
h = histogram(h_normalized,50);
p = histcounts(h_normalized,50,'Normalization','pdf');
% plotting the pdf using histogram of normalized resultant data
% also correcting number of bins in histogram command
% to plot smooth pdf curve with corresponding ranges
figure(6);
binCenters = h.BinEdges + (h.BinWidth/2);
plot(binCenters(1:end-1), p, 'r-')
xlabel('instantaneous value of the resultant amplitude');
ylabel('probability');
title('pdf of h(t)');