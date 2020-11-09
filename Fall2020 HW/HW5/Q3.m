%% Problem 3
clear all
close all
%% (a)
load hospitaladmissions.dat;
x = hospitaladmissions(:,4:5);
y = hospitaladmissions(:,6);
xdes = [ones(size(y)) x];
[n p] = size(xdes);
[b dev stats] = glmfit(x,y,'poisson','link','log')

%% (b)
mdl =  fitglm(x,y,'linear','Distribution','poisson');
xn = [44 100];
[yhatn,cin] = predict(mdl,xn,'Alpha',0.05,'Simultaneous',true)
