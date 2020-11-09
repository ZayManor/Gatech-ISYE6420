% IHGA
clear all
close all
 disp('Counting Data: Danish IHGA Project')

%-----------------figure defaults
lw = 2.5;  
set(0, 'DefaultAxesFontSize', 16);
fs = 15;
msize = 8;
randn('seed',3)
%-------------------------------------------------------------
% data
x0 = 0 * ones(287,1);  x1 = 1 * ones(285,1); 
% x0 (0=did not receive assistance); x1 (1=received assistance)
    %covariate 0-no intervention, 1- intervention
y0 = [0*ones(138,1); 1*ones(77,1); 2*ones(46,1);...
     3*ones(12,1); 4 * ones(8,1);  5*ones(4,1); 7*ones(2,1)]; 
y1 = [0*ones(147,1); 1*ones(83,1); 2*ones(37,1);...
     3*ones(13,1); 4 * ones(3,1);  5*ones(1,1); 6*ones(1,1)];
    %response # of hospitalizations
x =[x0; x1];  y=[y0; y1];
xdes = [ones(size(y)) x];
[n p] = size(xdes)

[b dev stats] = glmfit(x,y,'poisson','link','log') 
yhat = glmval(b, x,'log') %model predictive responses
%         stats.dfe %   degrees of freedom for errors        
%         stats.s   % theoretical or estimated dispersion parameter
%         stats.sfit% estimated dispersion parameter
%         stats.se%standard errors of coefficient estimates B
%         stats.coeffcorr% correlation matrix for B
%         stats.covb%      estimated covariance matrix for B
%         stats.t%         t statistics for B
%         stats.p%         p-values for B
%         stats.resid %     residuals
%         stats.residp%    Pearson residuals
%         stats.residd%    deviance residuals
%         stats.resida%    Anscombe residuals


% Pearson residual
rpea  = (y - yhat)./sqrt(yhat)
% deviance residuals 
rdev = sign(y - yhat) .* sqrt(  -2*y.*log( yhat./(y + eps)) - 2*(y - yhat) ) 
% Friedman-Tukey residuals 
rft = sqrt(y) + sqrt(y + 1) - sqrt(4 * yhat + 1)
% Anscombe residuals
ransc = 3/2 * (y.^(2/3) - yhat.^(2/3) )./(yhat.^(1/6))
  figure(1)
  range = 1:length(x)
  subplot(2,2,1)
  plot(y, rpea, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')
                                          hold on;  plot( [-0.5 7.5],[0,0],'k-')  
                                          axis([-0.5 7.5 -2 6.5])
                                          xlabel('$y$','Interpreter','LaTeX')
                                          ylabel('Pearson Res.','Interpreter','LaTeX')
                                          
  subplot(2,2,2)
  plot(y , rdev, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')  
                                       hold on;  plot( [-0.5 7.5],[0,0],'k-')
                                        axis([-0.5 7.5 -2 4.5])
                                       xlabel('$y$','Interpreter','LaTeX')
                                       ylabel('Deviance Res.','Interpreter','LaTeX')
  subplot(2,2,3)
  plot(y  , rft, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')  
                                       hold on;  plot( [-0.5 7.5],[0,0],'k-')
                                       axis([-0.5 7.5 -2 4])
                                      xlabel('$y$','Interpreter','LaTeX')
                                      ylabel('Friedman-Tukey Res.','Interpreter','LaTeX')
  subplot(2,2,4)
  plot(y , ransc, 'o','MarkerSize',8, 'MarkerEdgeColor','k',...
                                           'MarkerFaceColor','g')
   hold on;  plot([-0.5 7.5],[0,0],'k-')
   axis([-0.5 7.5 -2 4.5])
      xlabel('$y$','Interpreter','LaTeX')
      ylabel('Anscombe Res.','Interpreter','LaTeX')
 %print -depsc 'C:\Springer\Logistic\Logisticeps\ihga4.eps'                                      


figure(2)

  plot(1:287, rdev(1:287), 'o','MarkerSize',8, 'MarkerEdgeColor','r',...
                                           'MarkerFaceColor','r')  
                                hold on;                                 
  plot(288:572, rdev(288:572), 'o','MarkerSize',8, 'MarkerEdgeColor','b',...
                                           'MarkerFaceColor','b') 
                      plot( [0,1],[0,0],'k-')                   
                     xlabel('Index','Interpreter','LaTeX')
                     ylabel('Deviance Res.','Interpreter','LaTeX')
                    h= legend('$x=0$','$x=1$',2); set(h, 'Interpreter','LaTeX')
% print -depsc 'C:\Springer\Logistic\Logisticeps\ihga3.eps'

                                    
   sum(rdev.^2)
   dev
   
     lin =  xdes * b      
     %loglik = sum( y  .*  lin   - exp(lin)   - log(factorial(y))  );  
     loglik = sum(y  .* log(yhat+eps) - yhat  - log(factorial(y)));
     % if y is larger better stability is achieved with 
     % gammaln(y+1) = log(facrorial(y))
%    
     [b0, dev0, stats0] = glmfit(zeros(size(y)),y,'poisson','link','log')
     yhat0 = glmval(b0, zeros(size(y)),'log');
     loglik0  = sum( y .* log(yhat0 + eps) - yhat0 - log(factorial(y)))
     
     G2 = -2 * (loglik0 -  loglik)  %LR test, nested model chi2  5.1711
     dev0 - dev % the same as G2, difference of deviances   5.1711
     pval = 1-chi2cdf(G2,1)     %0.0230

    
      
% The deviance (likelihood ratio) test statistic, G2, 
% is the most useful summary of the adequacy of the fitted model. 
% It represents the change in deviance between the fitted model 
% and the null model (model with an intercept and no covariates}
% If this test is significant then the covariates contribute significantly to the model.
% It is distributed as Chi2 with p-1 df.

   %log-likelihood for saturated model
      logliksat  = sum( y  .*  log(y+eps)   - y   - log(factorial(y)))
       %-338.1663
      m2LL = -2 * sum( y  .* log(yhat./(y + eps)) ) % 819.8369
      deviance = sum(rdev.^2) %819.8369
      dev  %819.8369   from glmfit
      -2*(loglik - logliksat) % 819.8369
      
       
      BIC = deviance + p * log(n)  %832.5352
  