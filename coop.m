hasCoop = zeros(length(au),1);
relay = zeros(length(p2),1);
for i = 1:length(au)
    r1 = pdist2(au(i,:),BS(i,:)); % d(AU,BS)
    r2 = pdist2(p2,au(i,:));
    a = min(r2);
    iu = find(r2 == a);
    r2 = a;
    D = pdist2(p2(iu,:),BS(i,:));
    if r2 <= r1 && D < r1
        hasCoop(i) = iu;
        relay(iu) = 1;
    end      
end
relays = p2(logical(relay),:);
j = 1;
for i = 1:length(relays)
    while(hasCoop(j) == 0)
        j = j+1;
    end
    hasCoop(j) = i;
    j = j+1;
end
% save ('hasCoop.mat', 'hasCoop');
% save ('relay.mat','relay');
% save ('relays.mat', 'relays')
CoopProbability = sum(logical(hasCoop))/length(au);