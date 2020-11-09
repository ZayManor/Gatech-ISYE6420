% ARRYTHMIA.M
clear all
close all
 disp('Binary Response: Arrythmia Example Revisited')

%-----------------figure defaults
lw = 2.5;  
set(0, 'DefaultAxesFontSize', 16);
fs = 15;
msize = 8;
randn('seed',3)
%-------------------------------------------------------------

load 'Arrhythmia.mat'
 Y = Arrhythmia(:,1);
 X = Arrhythmia(:,2:11);   %Design matrix n x (p-1) without 
                           %vector 1 (intercept)
 Xdes =[ones(size(Y)) X];  %with the intercept: n x p
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
 xlabel('Linear Predictor: $b_0 + b_1 X_1 + ... + b_{10}   X_{10}$','Interpreter','LaTeX')
 ylabel('Probability of Arrhythmia','Interpreter','LaTeX') 
 legend('Observations','Logistic Fit',2)
 print -depsc 'C:\Springer\Logistic\Logisticeps\arrh1.eps'


  phat = exp(lin)./(1 + exp(lin));
  V = diag( phat .* (1 - phat) ); 
  sqrtV = diag( sqrt(phat .* (1 - phat) ))
  sb = sqrt(   diag( inv( Xdes' * V * Xdes ) ) )
  % inv( Xdes' * V * Xdes ) is stats.covb
  % Wald tests for parameters beta
  z = b./sb  %tests for beta_i = 0, i=0,...,p-1
  pvals = 2 * normcdf(-abs(z))   %p-values 
  %0.0158    0.0005    0.3007    0.2803    0.1347    0.8061   
  %0.4217    0.3810    0.6762    0.0842    0.5942

  figure(2)
  range = [2:7];
  errorbar(range-1, b(range), 1.96*sb(range),'o','MarkerSize',msize,...
       'LineWidth',2,   'MarkerEdgeColor','k','MarkerFaceColor','g')  
  hold on
  plot([-1:12],0*[-1:12],'r-')
  xlabel('Index','Interpreter','LaTeX');  ylabel('$b \pm 1.96 s_b$','Interpreter','LaTeX')
  axis([0.5 6.5 -0.4 0.3])
  hold off
  
  figure(3)
  range = [1:11];
  errorbar(range-1, b(range), 1.96*sb(range),'o','MarkerSize',msize,...
       'LineWidth',2,   'MarkerEdgeColor','k','MarkerFaceColor','g')  
  hold on
  plot([-1:12],0*[-1:12],'r-')
  xlabel('Index','Interpreter','LaTeX'); ylabel('$b \pm 1.96 s_b$','Interpreter','LaTeX')
   axis([-0.5 10.5 -20 4])
  hold off
  %print -depsc 'C:\Springer\Logistic\Logisticeps\arrhrb.eps'
   
%  %(1-alpha)*100% CI for betas
   CIs = [b - norminv(1 - alpha/2) * sb , b + norminv(1-alpha/2) * sb]
   %(1-alpha)*100% CIs for odds ratios
   CIsOR = exp([b-norminv(1-alpha/2)*sb , b+norminv(1-alpha/2)*sb])
   
%     0.0000    0.1281
%     1.0697    1.2711
%     0.9781    1.0744
%     ...
%     0.8628   10.3273
%     0.4004    4.9453

   
% 
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
%   
    
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
%   
%   
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
%   
%   
  figure(4)
  subplot(2,2,1)
  plot( phat, ro, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')
                                          hold on;  plot( [0,1],[0,0],'k-')  
                                          xlabel('$\hat p$','Interpreter','LaTeX')
                                          ylabel('Ordinary Res.','Interpreter','LaTeX')
  subplot(2,2,2)
  plot( phat, rpea, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')  
                                       hold on;  plot( [0,1],[0,0],'k-')  
                                       xlabel('$\hat p$','Interpreter','LaTeX')
                                       ylabel('Pearson Res.','Interpreter','LaTeX')
  subplot(2,2,3)
  plot( phat, rdev, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')  
                                       hold on;  plot( [0,1],[0,0],'k-')
                                      xlabel('$\hat p$','Interpreter','LaTeX')
                                      ylabel('Deviance Res.','Interpreter','LaTeX')
  subplot(2,2,4)
  plot( phat, ransc, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')
   hold on;  plot( [0,1],[0,0],'k-')
      xlabel('$\hat p$','Interpreter','LaTeX')
      ylabel('Anscombe Res.','Interpreter','LaTeX')
 print -depsc 'C:\Springer\Logistic\Logisticeps\arrh4.eps'                                      
                                       
%  If the model is adequate, the loess smoothing
%  of residuals (Pearson) should result in a function close to 0
      g = loess(phat,rpea,phat,1,1,1)
     g1 = loess(phat,rdev,phat,1,1,1)
%    apply loess curve fit -- nonparametric regression
%    x,y  data points
%    newx,g  fitted points
%    alpha  smoothing  typically 0.25 to 1.0
%    lambda  polynomial order 1 or 2
%    if robustFlag is present, use bisquare                                    
  figure(5)
  plot(phat, rpea, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')
  hold on
  plot(phat, g,'o','MarkerSize',3, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','r')
                                        
                                       
  plot( [0,1],[0,0],'k-')
  xlabel('$\hat p$','Interpreter','LaTeX')
  h=legend('Pearson Residuals','Loess Smoothed',1);set(h,'Interpreter','LaTeX')

  
  print -depsc 'C:\Springer\Logistic\Logisticeps\arrh5.eps'
  %
  figure(6)
  plot(phat, rdev, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')
  hold on
  plot(phat, g1,'o','MarkerSize',3, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','r')
  plot( [0,1],[0,0],'k-') 
  xlabel('$\hat p$','Interpreter','LaTeX')
  legend('Deviance Residuals','Loess-Smoothed',1);set(h,'Interpreter','LaTeX')
  print -depsc 'C:\Springer\Logistic\Logisticeps\arrh6.eps'
%   
%   
%   % INFLUENTIAL  OBSERVATIONS
%  Half normal Probability Plot of the deviance residuals are
%  used for checking adequacy of the linear part of the model and 
%  detection of outlying  residuals

% Half normal plot in GLM setting is an extension of Atkinsons (1985) half
% normal plot in regular linear regression models. In the plot the absolute
% values of the deviance residuals rD
% i are ordered and the kth largest absolute
% residual is plotted against z( (k+n?1/8)/(2n+1/2) ). Here,
% (k+n?1/8)/(2n+1/2) is suggested by Blum.  
% z(q) is the q-percentile of the standard normal distribution. 
% As in the linear regression model, the half
% normal plot in GLM setting can also be used to detect influential points.
% 


  figure(7)
  k = 1:n;
  q = norminv((k + n - 1/8)./(2 * n + 1/2));
  plot( q, sort(abs(rdev)),  'k-','LineWidth',1.5);
 
  % Simulated Envelope
  rand('state',1)
  env =[];
for i = 1:19
  surrogate = binornd(1, phat);
  rdevsu = sign(surrogate - phat).*sqrt(- 2*surrogate .* log(phat+eps) ...
      - 2*(1 - surrogate) .* log(1 - phat+eps) );
  env = [env   sort(abs(rdevsu))];
end
envel=[min(env'); mean(env' ); max(env' )]'; 
hold on
plot( q , envel(:,1), 'r-');
plot( q , envel(:,2), 'g-');
plot( q , envel(:,3), 'r-');
xlabel('Half-Normal Quantiles','Interpreter','LaTeX'); 
ylabel('Abs. Dev. Residuals','Interpreter','LaTeX')
h=legend('Abs. Residuals','Simul. $95\%$ CI','Simul. Mean',2);set(h,'Interpreter','LaTeX')
axis tight
print -depsc 'C:\Springer\Logistic\Logisticeps\arrh7.eps'


%
% PROBABILITY OF Y=1 FOR A NEW OBSERVATION
Xh =[1  72  81  130  15  78  43  1   0   0   1]' ;   
% responses for a new person
pXh = exp(Xh' *  b)/(1 + exp(Xh' * b) ) %0.3179
%(1-alpha) * 100% CI
ppXh = Xh' * b  %-0.7633 
s2pXp = Xh' * inv( Xdes' * V * Xdes ) * Xh  %0.5115
spXh = sqrt(s2pXp)   %0.7152
% confidence interval on the linear part
li = [ppXh - norminv(1-alpha/2) * spXh   ppXh + norminv(1-alpha/2) * spXh]
%  -2.1651    0.6385
% transfromation to the CI for the mean response
exp(li)./(1 + exp(li)) %0.1029    0.6544


% PREDICTING SINGLE FUTURE OBSERVATION

cutoff = sum(Y)/n %0.3457
% often taken as 0.5
% 
pXh > cutoff  %Ynew = 0

%HOSMER LEMESHOW
phato =sort(phat);
