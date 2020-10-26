%norcaugibbs.m
clear all
close all force
randn('state',4);

data = [100,106,110,97,90,112,120,95,96,109];
yhat = 103.5;
%
lendata=length(data);
sumdata=sum(data);

sigma2 = 90;
tau2 = 120;
mu = 110;
%
theta = 0;
thetas =[theta];
lambda = gamma(0.5);
lambdas=[lambda];
burn =1000;
ntotal = 10000 + burn;
tic
for i = 1: ntotal
  theta = (tau2/(tau2 + lambda * sigma2) * yhat + ...
    lambda * sigma2/(tau2 + lambda * sigma2) * mu) + ...
    sqrt(tau2 * sigma2/(tau2 + lambda *sigma2)) * randn;
  lambda =  exprnd( 1/((tau2 + (theta - mu)^2)/(2*tau2)));
thetas =[thetas theta];
lambdas =[lambdas lambda];
end
toc
%
 mean(thetas(burn+1:end))
 var(thetas(burn+1:end))
 hist(thetas(burn+1:end), 40)
 prctile(thetas(burn+1:end), 2.5)
 prctile(thetas(burn+1:end), 97.5)