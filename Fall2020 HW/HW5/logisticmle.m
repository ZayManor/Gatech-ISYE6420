%% logisticmle.m

function [bs,stderr,phat,deviance] = logisticmle(y,x)
%[bs,stderr,phat,deviance] = logisticmle(y,x)
%  Input:
% y - responses, a binary vector, values 0 and 1
% x - the covariate, as a vector
%
% Output:
% bs - estimators of beta0 and beta1
% stderr - standard error of the estimate
% phat - estimator of p= P(Y=1)
% deviance - deviance
%
%
x=x(:); y=y(:);  
 %initialize at LS estimate if vector bstart not given
b1 =  sum((y-mean(y)).*(x-mean(x)))/sum((x-mean(x)).^2);
b0 =  mean(y) - b1 * mean(x);
bs= [b0; b1];
%=============================================
% Refine bs by Newton-Raphson
diff = 1;   precision = 1.0E-6;    
while diff > precision;
    bsold = bs;
    p = exp(bs(1)+bs(2)*x)./(1+exp(bs(1)+bs(2)*x));
    score =   [sum(y-p);  sum((y-p).*x)];
    Infmat =  [sum(p.*(1-p))                    sum(p.*(1-p).*x); 
                      sum(p.*(1-p).*x)                sum(p.*(1-p).*x.*x)   ];
    bs =    bsold + Infmat\score;
    diff =         sum((bs-bsold).^2); 
end
Covmat = inv(Infmat);
stderr = sqrt(diag(Covmat));
phat = exp(bs(1)+bs(2)*x)./(1+exp(bs(1)+bs(2)*x));
deviance = 2* sum( y.* log((y+eps)./phat)  + ...
    (1-y) .*log((1-y+eps)./(1-phat)) );