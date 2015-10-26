Ps= 1;
snr = zeros(10,1);
averageAssistedRate = zeros(10,1);
averageRate = zeros(10,1);
lessRate = zeros(10,1);
for j = 1:10
    alpha1 = 0.5;
    alpha2 = 1 - alpha1;

%     beta1 = 0.1;
%     beta2 = 1-beta1;

    Psb = alpha1*Ps;
    Psm = alpha2*Ps;
%     Psm1 = beta1*Psm;
%     Psm2 = beta2*Psm;
    Pr = Ps;
    Prm = Pr/alpha2;
    gamma = 3; % pathloss exponent
    Pnoise = 1;
    p4 = au; 
    p5 = relays;
    assistedRate = zeros(length(p4),1);
    cellEdger = zeros(length(p4),1);
    R2 = zeros(length(p4),1);
    R1 = zeros(length(p4),1);
   
%     r2byr1 = zeros(length(p4),1);
    rate = zeros(length(p4),1);
    % C = zeros(length(p4),1);
    % C1 = zeros(length(p4),1);
    % C2 = zeros(length(p4),1);


    for k=1:length(p4)

        rsd = pdist2(p4,BS(k,:));

        gsd1 =  exprnd(1,length(rsd),1);
        hsd1Squared = gsd1.*(rsd.^(-gamma));

        rrd = pdist2(p5,BS(k,:));

        grd = exprnd(1,length(rrd),1);
        hrdSquared = grd.*(rrd.^(-gamma));

        gsd2 = exprnd(1,length(rsd),1);
        hsd2Squared = gsd2.*(rsd.^(-gamma));

        Idb = sum(hsd1Squared*Ps) - hsd1Squared(k)*Ps + Pnoise;
        hsdtilde1Squared = hsd1Squared(k)/Idb;


        rel = hasCoop(k);
        if rel > 0

            Idb = sum(hsd1Squared(hasCoop~=0)*Psb) + sum(hsd1Squared(hasCoop==0)*Ps) - hsd1Squared(k)*Psb + Pnoise;
            hsdtilde1Squared = hsd1Squared(k)/Idb;

            Idm = sum(hrdSquared*Prm) + sum(hsd2Squared(hasCoop~=0)*Psm) + sum(hsd2Squared(hasCoop==0)*Ps)+Pnoise;
    %     hsdtilde2Squared = hsd2Squared(i)/(Idm-hsd2Squared(i)*Psm);


            hrdtildeSquared = hrdSquared(rel)/(Idm - hrdSquared(rel)*Prm - hsd2Squared(k)*Psm);
    
            hsdtilde2Squared = hsd2Squared(k)/(Idm-hsd2Squared(k)*Psm - hrdSquared(rel)*Prm);

            rsr = pdist2(p4,p5(rel,:));
            gsr =  exprnd(1,length(rsr),1);
            hsrSquared = gsr.*(rsr.^(-gamma));
            Irb = sum(hsrSquared(hasCoop~=0)*Psb) + sum(hsrSquared(hasCoop==0)*Ps) - hsrSquared(k)*Psb + Pnoise;
            hsrtildeSquared = hsrSquared(k)/Irb;

            C = @(beta1) -alpha1*log(1+hsrtildeSquared*Psb)-alpha2*log(1+hsdtilde2Squared*(1-beta1)*Psm);
            %C2 = alpha2*log(1+hsdtilde2Squared*beta2*Psm);
            C3 = @(beta1) -alpha1*log(1 + hsdtilde1Squared*Psb) - alpha2*log(1+hsdtilde2Squared*(1-beta1)*Psm + ( sqrt(hsdtilde2Squared*beta1*Psm) + sqrt(hrdtildeSquared*Prm))^2);
            [BETA,assistedRate(k)] = fminbnd(@(beta1) min(C(beta1), C3(beta1)),0,1);
            %assistedRate(i) = min(C, C1+C2);
            assistedRate(k) = -assistedRate(k);
            
%             R2(i) = pdist2(p4(i,:),p5(rel,:));
%             R1(i) = pdist2(p4(i,:),BS(i,:));
%             
%             if R1(i) > 7.5
%                 cellEdger(i) = 1;
%             end
%             r2byr1(i) = R2(i)/R1(i);

        else

            Idm = sum(hrdSquared*Prm) + sum(hsd2Squared(hasCoop~=0)*Psm) + sum(hsd2Squared(hasCoop==0)*Ps)+Pnoise;
            hsdtilde2Squared = hsd2Squared(k)/(Idm-hsd2Squared(k)*Ps);
            assistedRate(k) = alpha1*log(1+hsdtilde1Squared*Ps)+alpha2*log(1+hsdtilde2Squared*Ps);
           % rate(i) = assistedRate(i);
        end
        rate(k) = alpha1*log(1+hsdtilde1Squared*Ps)+alpha2*log(1+hsdtilde2Squared*Ps);
    end
    averageAssistedRate(j) = mean(assistedRate)/log(2);
    averageRate(j) = mean(rate)/log(2);
    snr(j) = 10*log(Ps/Pnoise)/log(10);
    Ps = 3*Ps;
end
% plot(snr,averageAssistedRate,'r');
% hold on
% plot(snr,averageRate);
%plot(snr,lessRate);