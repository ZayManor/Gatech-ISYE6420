%% Problem 2
% %% (a)
% X = [1.35, 1.6, 1.75, 1.85, 1.95, 2.05, 2.15, 2.25, 2.35];
X = [1.35 1.6 1.75 1.85 1.95 2.05 2.15 2.25 2.35];
S = [13 19 67 45 71 50 35 7 1];
D = [0 0 2 5 8 20 31 49 12];
Y = S./(S+D);
[bs,stderr,phat,deviance] = logisticmle(Y,X);
% output
bs
deviance

%% another approach
clear all
close all
disp('Problem 2')

%-----------------figure defaults
lw = 2.5;  
set(0, 'DefaultAxesFontSize', 16);
fs = 15;
msize = 8;
randn('seed',3)

X = [1.35, 1.6, 1.75, 1.85, 1.95, 2.05, 2.15, 2.25, 2.35];
S = [13, 19, 67, 45, 71, 50, 35, 7, 1];
D = [0, 0, 2, 5, 8, 20, 31, 49, 12];
Y = S./(S+D);

X = X';
Y = Y';

Xdes =[ones(size(Y)) X];
[n p] = size(Xdes);
alpha = 0.05;  %alpha for CIs

[b, dev, stats]=glmfit(X,Y, 'binomial','link','logit')
lin = Xdes * b  %linear predictor, n x 1 vector

figure(1)
plot(lin, Y,'o','MarkerSize',msize,...
          'MarkerEdgeColor','k','MarkerFaceColor','g')          
xx = -6:0.01:4;
mp =  exp(xx)./(1 + exp(xx));
hold on
plot(xx, mp,'r-','LineWidth',lw)
axis([-6 4 0 1])
xlabel('Linear Predictor: $b_0 + b_1 X_1$','Interpreter','LaTeX')
ylabel('Probability of Arrhythmia','Interpreter','LaTeX') 
legend('Observations','Logistic Fit','Location', 'NorthWest')

phat = exp(lin)./(1 + exp(lin));
V = diag( phat .* (1 - phat) ); 
sqrtV = diag( sqrt(phat .* (1 - phat) ))
sb = sqrt(   diag( inv( Xdes' * V * Xdes ) ) )
% inv( Xdes' * V * Xdes ) is stats.covb
% Wald tests for parameters beta
z = b./sb  %tests for beta_i = 0, i=0,...,p-1
pvals = 2 * normcdf(-abs(z))   %p-values 

%  %(1-alpha)*100% CI for betas
CIs = [b - norminv(1 - alpha/2) * sb , b + norminv(1-alpha/2) * sb]
%(1-alpha)*100% CIs for odds ratios
CIsOR = exp([b-norminv(1-alpha/2)*sb , b+norminv(1-alpha/2)*sb])

%Log-likelihood
loglik = sum( Y  .* lin - log( 1 + exp(lin) ))  %-39.1258
%fitting null model. 
[b0, dev0, stats0] = glmfit(zeros(size(Y)),Y,'binomial','link','logit')
  %b0=-0.6381,  dev0=104.4464, stats=... (structure)
loglik0 = sum( Y  .* b0(1) - log(1 + exp(b0(1))) ) %-52.2232
%   
G = -2 * (loglik0 -  loglik)  % 26.1949 
dev0 - dev %26.1949, the same as G, difference of deviances
%   
%model deviance
devi = -2 * sum( Y  .* log( phat + eps) + (1-Y ).*log(1 - phat + eps) )  
                   %78.2515,  directly 
dev                %78.2515,  glmfit output
-2 * loglik        %78.2515,  as a link between loglik and deviance

%McFadden Pseudo R^2
mcfadden = 1 - loglik/loglik0 %0.2508
1 - dev/dev0 %0.2508
G/dev0 %0.2508
%   
mcfaddenadj = 1 - (loglik - 6)/loglik0 
%0.1359 counterpart to R2adj, p=5 parameters
%   
coxsnell  = 1 - (exp(loglik0)/exp(loglik) )^(2/n) %0.2763
%   
nagelkerke = (1-(exp(loglik0)/exp(loglik))^(2/n))/( 1-exp(loglik0)^(2/n))
%0.3813
%   
effron = 1 -  sum((Y  - phat).^2)/sum((Y  - sum(Y )/n ).^2) %0.2811

%   %%%RESIDUAL ANALYSIS
%   
ro = Y  - phat;  %ordinary residuals, generally noninformative,
% the distribution of ordinary residuals variable and unknown.
rpea = ro./sqrt( phat .*(1-phat) ); %Pearson Residuals 
%sum of rpea^2 is Chi^2 statistics, when data in Binomial shape, it is Chi2 with df =
%c-p, when in Bernoulli shape sum distribution is not chi2.
%   
%Studentized Pearson: Pearson residuals are divided with their estimated
%standard deviation. Estimated hat-matrix H=W^(1/2) X (X' W X)^(-1) X'
%W^(1/2), W = diag( phat_i (1- phat_i) ), Y = HY.
% 
%    H = sqrtV * Xdes * inv(Xdes' * V * Xdes) * Xdes' * sqrtV;
%    hii = diag(H);
%    rstpea = rpea./sqrt(1 - hii);


%Deviance Residuals
rdev = sign(Y  - phat) .* sqrt( - 2 * Y  .* log(phat+eps) - 2*(1 - Y ) .* log(1 - phat+eps));
%Anscombe Residuals    
ransc = (betainc(Y , 2/3, 2/3) - betainc(phat, 2/3, 2/3) ) .* ( phat  .* (1-phat) + eps).^(1/6);
% 
% Deviance as a sum of squared rev. residuals
sum(rdev.^2)  %78.2515
% or as an output from glmfit
dev %78.2515