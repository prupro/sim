hasCoop = zeros(length(au),1);
relay = zeros(length(p2),1);
gamma = 3;
for i = 1:length(au)
    r1 = pdist2(au(i,:),BS(i,:)); % d(AU,BS)
    r2 = pdist2(p2,au(i,:));
    a = min(r2);
    iu = find(r2 == a);
    r2 = a;
    D = pdist2(p2(iu,:),BS(i,:));
    gsd = exprnd(1,1,1);
    gsr = exprnd(1,1,1);
    if gsd*(r1^-gamma) <= gsr*(r2^-gamma)  && D < r1
        hasCoop(i) = iu;
        relay(iu) = 1;
    end      
end
relays = p2(logical(relay),:);

for j = 1:length(au)
    if hasCoop(j) == 0
        continue
    end
    t = hasCoop(j);
    hasCoop(j) = numel(find(relay(1:t)>=1));
end
% save ('hasCoop.mat', 'hasCoop');
% save ('relay.mat','relay');
% save ('relays.mat', 'relays')
CoopProbability = sum(logical(hasCoop))/length(au);