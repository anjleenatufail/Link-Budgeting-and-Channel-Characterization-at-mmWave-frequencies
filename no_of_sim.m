clc
clear all
tic
% declaring a new matrix variable
dirpdp_contentnew=[];
% loop for 10000 simulation run
for no_of_simulation=1:10000 
    % calling base code of NYUSIM
    MainCode_drop_v31
    % measuring matrix size
    [no_rows,no_columns]=size(dirpdp_content(:,1));
    run_number=zeros(no_rows,1);
    % initialising the simulation run number
    run_number(1:no_rows,1)=no_of_simulation;
    % appending to matrix data from NYUSIM base code
    dirpdp_content(:,1)=run_number;
    dirpdp_content(1,1)
    % appending the matrix data from NYUSIM base code
    % to new matrix variable in current program
    dirpdp_contentnew=[dirpdp_contentnew;dirpdp_content];
end
% saving the new matrix variable after 10000 simulations
save('dirpdpnewsimulation.mat', 'dirpdp_contentnew');
toc