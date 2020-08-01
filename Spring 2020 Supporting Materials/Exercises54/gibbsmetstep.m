%
% Kidney Cancer in Georgia 1985-1989 by county
%
close all
clear all

%rand('seed',2);
%randn('seed',2);
filename = 'C:\Brani\Courses\isyestatg\ISyE6420Spring2018\HWs\georgiakcd.xlsx';

 
data = xlsread(filename,  'B:D');

 y = data(:,2);
 ni = data(:,3)/100000;
 [n ~]=size(data);
 A=10;
 B=10;
 % 
lambda = ones(n,1); % initial values
alpha = 1;
beta=1;
sigma=0.1;
%
lambdas =[lambda]; %save all lambdas
alphas =[alpha];
betas= [beta];
%
% 
tic
for i = 1:20000  %beware slow...
   prodlambdas = prod(lambda);
   sumlambdas = sum(lambda);
   % lambda_k ~ Gamma(y_k + alpha, ni_k + beta), k=1,...,n
   lambda=zeros(n,1);
   for k = 1:n
       lambda(k) = gamrnd(y(k)+alpha, 1/(ni(k)+beta));
   end
   lambdas=[lambdas  lambda];
   
   % METROPOLIS STEP for alpha
   alpha_prop =  alpha + sigma*randn; 
   c= prodlambdas * beta^n;
   if   (alpha_prop < A) .* (alpha_prop > 0) 
          r = (gamma(alpha).^n * c^alpha_prop)/(gamma(alpha_prop).^n * c^alpha) ;
   else
          r = 0;
   end
   if rand < r
       alpha = alpha_prop;
   end
   alphas=[alphas alpha];
   % RESTRICTED GAMMA for beta
   
   beta_new = B+1;
   while beta_new > B 
        beta_new = gamrnd(n*alpha + 1, 1/sumlambdas);
   end
   beta = beta_new;
   betas = [betas beta];
  end
toc
%Burn in 500
burn=500;
 lambdas = lambdas(:, burn+1:end);
 alphas = alphas(burn+1:  end);
  betas = betas(burn+1: end);
figure(1)
nbins=30;
subplot(3,1,1)
histogram(lambdas(33,:),nbins,'Normalization','Probability')
subplot(3,1,2)
histogram(alphas,nbins,'Normalization','Probability') 
subplot(3,1,3)
histogram(betas,nbins,'Normalization','Probability') 
print -depsc 'gacancer1.eps')

figure(2)
subplot(3,1,1)
plot(lambdas(33,2000:2200),'-')
axis tight 
subplot(3,1,2)
plot(alphas(2000:2200),'-')
axis tight 
subplot(3,1,3)
plot(betas(2000:2200),'-')
axis tight 
print -depsc 'gacancer2.eps')
 
ma=mean(alphas)
mb=mean(betas)
mla = mean(lambdas')
ma/mb
sum(y)/sum(ni)