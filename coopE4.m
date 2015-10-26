hasCoop = zeros(length(au),1);
for i = 1:length(au)
    r1 = pdist2(au(i,:),BS(i,:)); % d(AU,BS)
    r2 = pdist2(p2,au(i,:));
    D = pdist2(p2,BS(i,:));
    pot = sum(r2<= r1 & D <= r1);
    hasCoop(i) = pot>0;    
end
CoopProbability = sum(hasCoop)/length(au);