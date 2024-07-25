clc
clear all; close all;
% initialising filename variable for loading the received power
% values corresponding to distances from 10m to 1000m
filename='dirpdpfading.mat';
foldername='D:\NYUSIM_V31_WIN_package\NYUSIM Base Code';
% loading the filename variable data
myfile=fullfile(foldername,filename);
load(myfile);
% loading each simulation run number for each distance, 10-1000m
SimNum = unique(dirpdp_contentfading(:,2));
% initialising matrix variable
A={};
Hf_pvs = cell(1,length(SimNum));
% calculating received power from PDP data
for id = 1:length(SimNum)
    clear Idx; Idx = find(dirpdp_contentfading(:,2)==SimNum(id));
    Hf_temp = sum(sqrt(10.^(dirpdp_contentfading(Idx,4)./10)) ...
        .*exp(1i.*dirpdp_contentfading(Idx,5)));
    % appending to A matrix
    A = [A; Hf_temp];
    Hf_pvs{1,id} = Hf_temp;
end
% converting cell type to matrix
Amp=cell2mat(Hf_pvs);
% measuring size of matrix
[r,c]=size(Amp);
for i=1:c
    A=[real(Amp(1,i)),imag(Amp(1,i))];
    % calculating resultant received power
    resultant(i)=sqrt(A(1,1)^2 + A(1,2)^2);
end
% x axis values for Path Loss plot
xtemp=[10:1000];
% plotting path loss values for the data from NYUSIM
figure(1);
% converting dBm to Watts
pt=sqrt(10^(40/10));
% calculating path loss
PL=pt./resultant;
% plotting path loss vs distance
plot(xtemp,10*log10(PL));
xlim([10 1000]);
hold on
% initialise frequency and speed values for calculating wavelength
c=3e8;
f=28e9;
lambda=c/f;
i=1;
% calculating path loss for 28GHz using MATLAB's fspl function
for r=10:1000
    pl_array(i)=fspl(r,lambda);
    i=i+1;
end
% scaling down the losses to show relation between two plots
for i=1:991
    pl_array(i)=pl_array(i)-22;
end
% plotting the path loss calculated using fspl function over
% the path loss plot obtained from NYUSIM data
figure(1);
plot(xtemp,pl_array,'Linewidth',2)
grid on
legend('Small Scale Effect','Large Scale Effect');
xlabel('distance(metre)');
ylabel('Loss(dB)');
title('Path Loss');