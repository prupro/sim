r1 = 10;
r2 = 6;
D = 8;

assistedRate = zeros(100,1);
rate = zeros(100,1);
SNR = zeros(10,1);
afRate = zeros(10,1);
directRate = zeros(10,1);

Ps = 1;

Pnoise = 1;
for i = 1:10
    
    Pr = Ps;
    
    for j = 1:100
    
        g13 = exprnd(1,1,1);
        g12 = exprnd(1,1,1);
        g23 = exprnd(1,1,1);

        gamma = 4;

        h13 = g13*(r1^(-gamma));
        h12 = g12*(r2^(-gamma));
        h23 = g23*(D^(-gamma));

        s0 = h13*Ps/Pnoise;
        s1 = h12*Ps/Pnoise;
        s2 = h23*Pr/Pnoise;
        
        C = 0.5*log(1+ s0 + s1*s2/(s1+s2+1));
        
        assistedRate(j) = C;
        
        rate(j) = log(1+s0);
        if C < rate(j)
           assistedRate(j) = rate(j); 
        end

    end
    afRate(i) = mean(assistedRate);
    directRate(i) = mean(rate);
    
    SNR(i) = 10*log(Ps/Pnoise);
    Ps = 5*Ps;

end

plot(SNR,afRate,'r');
hold on
plot(SNR,directRate)