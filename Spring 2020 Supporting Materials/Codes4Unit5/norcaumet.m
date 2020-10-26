%norcaumet.m
%
close all
clear all

rand('seed',1);
randn('seed',1);
x = -2; %data
theta = 0.5; % initial value
thetas =[theta]; %save all thetas.
%

tic
 for i = 1:100000
theta_prop = randn + x;  %N(x,1).
%--------------------------------------------------------------------------
r = (theta_prop^(-0.5)*exp(-1.85*theta))/(theta^(-0.5)*exp(-1.85*theta_prop));
%--------------------------------------------------------------------------
rho = min(r ,1);
   if (rand < rho)
       theta = theta_prop; 
   end
thetas =  [thetas theta];
end
toc
%Burn in 500
 thetas = thetas(500:end);
figure(1)
 hist(thetas, 50)
 mean(thetas)
  var(thetas)

