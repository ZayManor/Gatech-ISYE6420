%FALL 2019 -- MIDTERM Online Course ISyE6420 (Penguins) 
%full conditional distributions available
%
% y_i ¬ N(mu, 1/tau), i=1,...,n
% mu ¬ N(mu0, 1/tau0); mu0=45, tau0=1/4
% tau ¬ Ga(a,1/b); shape=4, rate=1/2
%------------------------------------------
clear all;
close all;
clc;
%-----------------figure defaults
lw=2;
set(0, 'DefaultAxesFontSize', 17);
fs=14;
msize = 5;
%--------------------------------
randn('state', 10);
data_1=[134 146 104 119 124 161 107 83 113 129 97 123];
n1=length(data_1);    % n=12
sum_1=sum(data_1);
data_2=[70 118 101 85 107 132 94];
n2=length(data_2);    % n=7
sum_2=sum(data_2);
%------------------------------------------
%
nn = 10000+1000;
theta_1s=[]; theta_2s=[]; tau_1s=[]; tau_2s=[];
% params
theta10=110; theta20=110; tau10=1/100; tau20=1/100;
a1=0.01; a2=0.01; b1=4; b2=4;
% init
theta1=110; theta2=110; tau1=1/100; tau2=1/100;
h=waitbar(0,'Simulation in progress');
for i = 1 : nn
    new_theta1 = normrnd( (tau1*sum_1+tau10*theta10)/(tau10+n1*tau1), sqrt(1/(tau10+n1*tau1)) );
    par1 = b1+1/2*sum((data_1-new_theta1).^2);
    new_tau1 =gamrnd(a1 + n1/2, 1/par1);
    theta_1s = [theta_1s new_theta1];
    tau_1s = [tau_1s new_tau1];
    theta1=new_theta1;
    tau1=new_tau1;
    
    new_theta2 = normrnd( (tau2*sum_2+tau20*theta20)/(tau20+n2*tau2), sqrt(1/(tau20+n2*tau2)) );
    par2 = b2+1/2*sum((data_2-new_theta2).^2);
    new_tau2 =gamrnd(a2 + n2/2, 1/par2);
    theta_2s = [theta_2s new_theta2];
    tau_2s = [tau_2s new_tau2];
    theta2=new_theta2;
    tau2=new_tau2;
    
    
    if i/50==fix(i/50)
        waitbar(i/nn)
    end
end
close(h)
%
burnin = 1000;
figure(1)
subplot(2,2,1)
hist(theta_1s(burnin:nn), 70)
xlabel('theta_1s')
subplot(2,2,2)
hist(theta_2s(burnin:nn), 70)
xlabel('theta_2s')
subplot(2,2,3)
hist(tau_1s(burnin:nn), 70)
xlabel('tau_1s')
subplot(2,2,4)
hist(tau_2s(burnin:nn), 70)
xlabel('tau_2s')
mean(theta_1s(burnin:nn))               %117.0744
mean(theta_2s(burnin:nn))               %104.7364
mean(tau_1s(burnin:nn))                 %0.0022
mean(tau_2s(burnin:nn))                 %0.0025
theta_diff = theta_1s-theta_2s;
mean(theta_diff)                        %12.3150
sum(theta_diff>0)/length(theta_diff)    %0.9192
prctile(theta_diff, 2.5)                %-4.9559
prctile(theta_diff, 97.5)               %28.9730
