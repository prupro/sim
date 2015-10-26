Ps= 1;
snr = zeros(10,1);
averageRate = zeros(10,1);
gamma = 3;
lambda = 1/(16*150^2);
Rc = 1/(2*sqrt(lambda));
r1 = 150;
Pnoise = 1;
for j = 1:10
    alpha1 = 0.5;
    alpha2 = 1 - alpha1;
    eps1 = Ps;
    eps2 = 2*Ps*Ps;
    Eq1 = (2*pi*lambda*eps1*Rc^(2-gamma))/(gamma-2);
    varq1 = (pi*lambda*eps2*Rc^(2*(1-gamma)))/(gamma-1);
    
    k1 = Eq1*Eq1/varq1;
    theta1 = varq1/Eq1;
    
    gsd1 = exprnd(1,1000,1);
    hsd1Squared = gsd1*r1^(-gamma);
    i1 = gamrnd(k1,theta1);
    hsdtilde1Squared = hsd1Squared/(i1+Pnoise);
    
    gsd2 = exprnd(1,1000,1);
    hsd2Squared = gsd2*r1^(-gamma);
    i2 = gamrnd(k1,theta1);
    hsdtilde2Squared = hsd2Squared/(i2+Pnoise);
   
    rate = alpha1*log(1+hsdtilde1Squared*Ps)+alpha2*log(1+hsdtilde2Squared*Ps);
    averageRate(j) = mean(rate)/log(2);
    snr(j) = 10*log(Ps/Pnoise)/log(10);
    Ps = 2*Ps;
end
plot(snr,averageRate);
