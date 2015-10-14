r1 = 10;
r2 = 5;
D = 5;

assistedRate = zeros(100,1);
rate = zeros(100,1);
SNR = zeros(10,1);
pdfRate = zeros(10,1);
directRate = zeros(10,1);

Ps = 1;
Pnoise = 1;
for i = 1:10
    
      
    alpha1=0.5;
    alpha2 = 1-alpha1;
    Psb = alpha1*Ps;
    Psm = alpha2*Ps;

%     beta1 = 6.6*10^(-5);
%     Psm1 = beta1*Psm;
%     Psm2 = (1-beta1)*Psm;

    Pr = Ps;
    Prm = Ps/alpha2;
    
    for j = 1:100
    
        g131 = exprnd(1,1,1);
        g12 = exprnd(1,1,1);
        g132 = exprnd(1,1,1);
        g23 = exprnd(1,1,1);

        gamma = 4;

        h131 = g131*(r1^(-gamma));
        h12 = g12*(r2^(-gamma));
        h132 = g132*(r1^(-gamma));
        h23 = g23*(D^(-gamma));

%         C1 = alpha1*log(1+h12*Psb);
%         C2 = alpha2*log(1+h132*Psm2);
% 
%         C3 =  alpha1*log(1+h131*Psb) + alpha2*log(1+h132*Psm2+(sqrt(h132*Psm1)+sqrt(h23*Prm))^2);
        
        C = @(beta1) -alpha1*log(1+h12*Psb) - alpha2*log(1+h132*(1-beta1)*Psm);

        C3 = @(beta1) -alpha1*log(1+h131*Psb) - alpha2*log(1+h132*(1-beta1)*Psm+(sqrt(h132*beta1*Psm)+sqrt(h23*Prm))^2);


        [BETA,assistedRate(j)] = fminbnd(@(beta1) min(C3(beta1),C(beta1)),0,1);
        
        %assistedRate(j) = min(C1+C2,C3);
        
        rate(j) = alpha1*log(1+h131*Ps/Pnoise) + alpha2*log(1+h132*Ps/Pnoise);

    end
    pdfRate(i) = mean(-assistedRate);
    directRate(i) = mean(rate);
    
    SNR(i) = 10*log(Ps/Pnoise);
    Ps = 5*Ps;

end

plot(SNR,pdfRate,'r');
hold on
plot(SNR,directRate)