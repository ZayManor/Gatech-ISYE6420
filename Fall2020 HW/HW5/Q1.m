%% Problem 1
%% (a)
load paddy.dat;
x = paddy(:,1);
y = paddy(:,2);
n = length(x);
C = ones(n,1);
X=[C x];
p = size(X,2);
params = inv(X'*X)*X'*y;
epsilon = params(1)
beta = params(2)
y_pred = epsilon + beta * x;
SSE = sum((y - y_pred).^2)
SST = sum((y - mean(y)).^2)
R2 = 1 - SSE/SST
%% (b)
xn = [1 2];
yn = params' * xn'
se_yn = sqrt(SSE/(n-p)) * sqrt(1 + xn*inv(X'*X)*xn')
alpha = 0.05;
lb = yn - tinv(1-alpha/2, n-p) * se_yn;
rb = yn + tinv(1-alpha/2, n-p) * se_yn;
[lb rb]