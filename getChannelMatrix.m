%%% NYUSIM - User License %%%

% Copyright (c) 2019 New York University and NYU WIRELESS

% Permission is hereby granted, free of charge, to any person obtaining a 
% copy of this software and associated documentation files (the “Software”),
% to deal in the Software without restriction, including without limitation 
% the rights to use, copy, modify, merge, publish, distribute, sublicense, 
% and/or sell copies of the Software, and to permit persons to whom the 
% Software is furnished to do so, subject to the following conditions:

% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software. Users shall cite 
% NYU WIRELESS publications regarding this work.

% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUTWARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
% OTHER LIABILITY, WHETHER INANACTION OF CONTRACT TORT OR OTHERWISE, 
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
% OTHER DEALINGS IN THE SOFTWARE.

% More information on NYUSIM, key relevant publications, and the user
% manual for NYUSIM can be found at the following links:
%
% [1] http://wireless.engineering.nyu.edu/5g-millimeter-wave-channel-modeling-software/
%
% [2] M. K. Samimi and T. S. Rappaport, “3-D millimeter-wave statistical
% channel model for 5G wireless system design”, IEEE Transactions on
% Microwave Theory and Techniques, vol. 64, no. 7, pp. 2207–2225, 2016.
% [Online]. Available: http://ieeexplore.ieee.org/document/7501500/.
%
% [3] S. Sun et al., “Investigation of prediction accuracy, sensitivity, and
% parameter stability of large-scale propagation path loss models for
% 5G wireless communications”, IEEE Transactions on Vehicular Technology,
% vol. 65, no. 5, pp. 2843–2860, 2016. [Online]. Available: http:
% //ieeexplore.ieee.org/document/7434656/.
%
% [4] G. R. MacCartney, Jr., S. Sun, T. S. Rappaport, Y. Xing, H. Yan, J.
% Koka, R. Wang, and D. Yu, “Millimeter wave wireless communications:
% New results for rural connectivity”, in All Things Cellular’16,
% in conjunction with ACM MobiCom, 2016. [Online]. Available: https:
% //arxiv.org/abs/1608.05384.
%
% [5] S. Sun, T. S. Rappaport, R. W. Heath, A. Nix, and S. Rangan, “MIMO
% for millimeter-wave wireless communications: Beamforming, spatial
% multiplexing, or both?”, IEEE Communications Magazine, vol. 52, no.
% 12, pp. 110–121, 2014. [Online]. Available: http://ieeexplore.
% ieee.org/document/6979962/.


%%% This script generates the channel matrix, and the corresponding condition 
%%% number and rank for each sub-carrier frequency and each RX location in a MIMO-OFDM system. 
%%% To run this script, the output data files "BasicParameters.mat" and
%%% "DirPDPInfo.mat" from NYUSIM (v2.01a) need to be put in the same directory with
%%% this script. 

%%% Modification in NYUSIM (v2.01a): The multipath delay stored in the data
%%% ``DirPDPInfo'' is in the unit of nanoseconds. The multipath delay is 
%%% multiplied by $10^{-9}$ to have the correct unit as seconds.

% Main Outputs:
%   - Hf: a cell containing the MIMO channel matrix for each sub-carrier
%   frequency and each RX location (i.e., each simulation run)
%   - cnHf: a number denoting the condition number in linear scale of each 
%   matrix in Hf
%   - cnHf_dB: a number denoting cnHf in dB
%   - rankHf: a number denoting the rank of each matrix in Hf, where the
%   rank is defined as the number of singular values of the channel matrix
%   that are larger than the maximum singular value of the channel matrix
%   divided by 1000   

clear; close all; tic
load('BasicParameters.mat'); % load the output data file containing the basic channel parameters
f = BasicParameters.Frequency; % center carrier frequency
RFBW = BasicParameters.Bandwidth; % RF bandwidth
Nt = BasicParameters.NumberOfTxAntenna; % number of transmit antenna elements
Nr = BasicParameters.NumberOfRxAntenna; % number of receive antenna elements
dTxAnt = BasicParameters.TxAntennaSpacing; % spacing between adjacent transmit antenna 
%   elements with respect to the wavelength
dRxAnt = BasicParameters.RxAntennaSpacing; % spacing between adjacent receive antenna 
%   elements with respect to the wavelength
load('DirPDPInfo.mat'); % load the output data file containing the channel impulse response parameters

% Remove NaN lines
nanInd = isnan(DirPDPInfo(:,3));
DirPDPInfo(nanInd,:) = [];

df = 500e3; % user-defined frequency interval between adjacent sub-carrier frequencies

% Find the unique simulation number to obtain the channel matrix for each of
% the TX-RX location pairs
SimNum = unique(DirPDPInfo(:,1));

j = sqrt(-1);
f_sub = f;
% *1e9-(RFBW*1e6)/2;
% :df:f*1e9+(RFBW*1e6)/2; % sub-carrier frequencies 
Hf = cell(length(f_sub),length(SimNum)); 
cnHf = zeros(length(f_sub),length(SimNum)); 
cnHf_dB = zeros(length(f_sub),length(SimNum));
rankHf = zeros(length(f_sub),length(SimNum));

for id = 1:length(SimNum)
    clear Idx; Idx = find(DirPDPInfo(:,1)==SimNum(id));
    for q = 1:length(f_sub)
        Hf_temp = zeros(Nr,Nt);
        for w = 1:Nr
            for y = 1:Nt
            % Generate the MIMO channel matrix for each individual sub-carrier frequency
            %%% Modification in NYUSIM (v2.01a): The multipath delay stored in the data
            %%% ``DirPDPInfo'' is in the unit of nanoseconds. The multipath delay is 
            %%% multiplied by $10^{-9}$ to have the correct unit as seconds. 
            Hf_temp(w,y) = sum(sqrt(10.^(DirPDPInfo(Idx,4)./10)).*exp(j.*DirPDPInfo(Idx,5)).*...
                exp(-j.*2.*pi.*f_sub(q).*DirPDPInfo(Idx,3)*1e-9).*... 
                exp(-j.*2.*pi.*dTxAnt.*y.*sin(DirPDPInfo(Idx,6).*pi./180)).*...
                exp(-j.*2.*pi.*dRxAnt.*w.*sin(DirPDPInfo(Idx,8).*pi./180)));
            end
        end
    Hf{q,id} = Hf_temp; 
    % Calculate the singular values of the matrix Hf_temp
    svHf = svd(Hf_temp); 
    % Calculate the condition number of the matrix Hf_temp
    cnHf(q,id) = max(svHf)/min(svHf); 
    % Convert the condition number from linear scale to dB scale
    cnHf_dB(q,id) = 10*log10(cnHf(q,id));
    % Calculate the rank of the matrix Hf_temp
    rankHf(q,id) = rank(Hf_temp,max(svHf)/1e3);
    end
end
    
toc