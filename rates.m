Ps= 10;
snr = zeros(10,1);
averageAssistedRate = zeros(10,1);
averageRate = zeros(10,1);
for j = 1:10
    alpha1 = 0.85;
    alpha2 = 1 - alpha1;

    beta1 = 0.1;
    beta2 = 1-beta1;

    Psb = alpha1*Ps;
    Psm = alpha2*Ps;
    Psm1 = beta1*Psm;
    Psm2 = beta2*Psm;
    Pr = Ps;
    Prm = Pr/alpha2;
    gamma = 4; % pathloss exponent
    Pnoise = 1;
    p4 = au; 
    p5 = relays;
    assistedRate = zeros(length(p4),1);
    rate = zeros(length(p4),1);
    % C = zeros(length(p4),1);
    % C1 = zeros(length(p4),1);
    % C2 = zeros(length(p4),1);


    for i=1:length(p4)

        rsd = pdist2(p4,BS(i,:));

        gsd1 =  exprnd(1,length(rsd),1);
        hsd1Squared = gsd1.*(rsd.^(-gamma));

        rrd = pdist2(p5,BS(i,:));

        grd = exprnd(1,length(rrd),1);
        hrdSquared = grd.*(rrd.^(-gamma));

        gsd2 = exprnd(1,length(rsd),1);
        hsd2Squared = gsd2.*(rsd.^(-gamma));

        Idb = sum(hsd1Squared*Ps) - hsd1Squared(i)*Ps + Pnoise;
        hsdtilde1Squared = hsd1Squared(i)/Idb;


        rel = hasCoop(i);
        if rel > 0

            Idb = sum(hsd1Squared*Psb) - hsd1Squared(i)*Psb + Pnoise;
            hsdtilde1Squared = hsd1Squared(i)/Idb;

            Idm = sum(hrdSquared*Prm) + sum(hsd2Squared*Psm)+Pnoise;
    %     hsdtilde2Squared = hsd2Squared(i)/(Idm-hsd2Squared(i)*Psm);


            hrdtildeSquared = hrdSquared(rel)/(Idm - hrdSquared(rel)*Prm - hsd2Squared(i)*Psm);
    %        if hrdtildeSquared > 0.0001
                hsdtilde2Squared = hsd2Squared(i)/(Idm-hsd2Squared(i)*Psm - hrdSquared(rel)*Prm);

                rsr = pdist2(p4,p5(rel,:));
                gsr =  exprnd(1,length(rsr),1);
                hsrSquared = gsr.*(rsr.^(-gamma));
                Irb = sum(hsrSquared*Psb) - hsrSquared(i)*Psb + Pnoise;
                hsrtildeSquared = hsrSquared(i)/Irb;

                C1 = alpha1*log(1+hsrtildeSquared*Psb);
                C2 = alpha2*log(1+hsdtilde2Squared*beta2*Psm);
                C = alpha1*log(1 + hsdtilde1Squared*Psb) + alpha2*log(1+hsdtilde2Squared*beta2*Psm + ( sqrt(hsdtilde2Squared*(1-beta2)*Psm) + sqrt(hrdtildeSquared*Prm))^2);
                %[BETA,assistedRate(i)] = fminbnd(@(beta1) -min(C, C1+C2),0,1);
                assistedRate(i) = min(C, C1+C2);
                %assistedRate(i) = -assistedRate(i);
     %       end
        else

            Idm = sum(hsd2Squared*Ps)+Pnoise;
            hsdtilde2Squared = hsd2Squared(i)/(Idm-hsd2Squared(i)*Ps);
            assistedRate(i) = alpha1*log(1+hsdtilde1Squared*Ps)+alpha2*log(1+hsdtilde2Squared*Ps);
           % rate(i) = assistedRate(i);
        end
        rate(i) = alpha1*log(1+hsdtilde1Squared*Ps)+alpha2*log(1+hsdtilde2Squared*Ps);
    end
    averageAssistedRate(j) = mean(assistedRate);%/log(2);
    averageRate(j) = mean(rate);%/log(2);
    snr(j) = 10*log(Ps/Pnoise);
    Ps = 5*Ps;
end
plot(snr,averageAssistedRate,'r-');
hold on
plot(snr,averageRate);