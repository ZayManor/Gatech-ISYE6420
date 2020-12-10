% problem 3
%(a)
data = importdata('hockpend.dat');
x1 = data(:,1);
x2 = data(:,2);
x3 = data(:,3);
Y = data(:,4);

vecones = ones(size(Y));
X =[vecones x1 x2 x3];
[n, p] = size(X);
b = inv(X' * X) * X'* Y;  % [8.855;3.420;-1.451;0.334]
H = X * inv(X' * X) * X';
Yhat=H*Y; %or Yhat =X*b;
J=ones(n); I = eye(n);
SSR = Y' * (H - 1/n * J) * Y;
SSE = Y' * (I - H) * Y;
SST = Y' * (I - 1/n * J) * Y;
MSR = SSR/(p-1);
MSE = SSE/(n-p);
F = MSR/MSE;
pval = 1-fcdf(F, p-1, n-p);
Rsq = 1 - SSE/SST;  % 0.8628
Rsqadj = 1 - (n-1)/(n-p) * SSE/SST;
s = sqrt(MSE);

%(c)
Xh=[1, 10, 5, 5];
Yh=Xh*b; % 37.4681
sig2h=MSE* Xh *inv(X'*X) *Xh'; 
sig2hpre=MSE*(1+Xh *inv(X'*X) *Xh'); 
sigh = sqrt(sig2h);
sighpre = sqrt(sig2hpre);
%95% CI’s on the individual responses 
[Yh-tinv(0.975, n-p)*sighpre, Yh+tinv(0.975, n-p)*sighpre]
% 30.1487   44.7874
