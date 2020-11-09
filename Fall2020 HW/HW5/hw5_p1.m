%% ISyE 6414 Summer 2017 HW#2 Solutions
%%%% Problem 1 Paddy %%%%
load paddy.dat
x = paddy(:,1);
y = paddy(:,2);
n = length(x);
vecones=ones(n,1);
X=[vecones x];
p = size(X,2); %p=2 number of parameters (beta0, beta1)
%% Part (a)
% estimators of coefficients beta1 and beta0
betas = inv(X'*X)*X'*y;
b0 =betas(1); % 0.3974
b1=betas(2); % 0.7693
% predictive equation (regression equation)
yhat = b0 + b1 * x
%residuals
res=y-yhat;
% ANOVA Identity
SST = sum( (y - mean(y)).^2 ) %the same as SST=21.7430
SSE = sum( (y - yhat).^2 ) %which is sum(res.^2)= 6.7232
Rsq=1-SSE/SST; % R^2=0.6908
%% Part (b)
% Standard error of coefficient estimators
sigma_hat=SSE/(n-p);
Var_mat=inv(X'*X);
Var_b0= Var_mat(1,1); % 0.0970
Var_b1=Var_mat(2,2); % 0.0394
se_b0=sqrt(Var_b0); % 0.3115
se_b1=sqrt(Var_b1); % 0.1985
df=n-p; % degrees of freedom fot t distribution = 41
beta0_hyp=0; % value of Null hypothesis for beta0
beta1_hyp=1; % value of Null hypothesis for beta1
% intercept H0: beta0 = 0 vs H1: beta0 > 0
t_0=(b0-beta0_hyp)/(sqrt(sigma_hat)*se_b0);  % 3.1509
pt_0 = 1- tcdf(t_0, df) % 0.0015
% we reject H0:beta0=0 at the 0.05 level.
% slope H0: beta1=1 vs H1: beta1 < 1
t_1=(b1-beta1_hyp)/(sqrt(sigma_hat)*se_b1); % -2.8693
pt_1 = tcdf(t_1, df) % 0.0032
% we reject H0:beta1=1 at the 0.05 level.
%% Part (c)
newx = [1 2]; % New steel measurement = 2
ypred = betas' * newx' % 1.9361
syp = sqrt(sigma_hat) * sqrt(1+newx*inv(X'*X)*newx') %s for prediction yhat = 0.4128
%intervals CI and PI
alpha = 0.05;
% prediction interval
lbyp = ypred - tinv(1-alpha/2, n-p) * syp;
rbyp = ypred + tinv(1-alpha/2, n-p) * syp;
%print the intervals
[lbyp rbyp] % 1.1025 2.7697