L = 200; 
area = L*L;
lambda1 = 1; % density of Active Users (AU)
lambda2 = 16; % density of Idle Users (IU)

N1 = poissrnd(lambda1*area); % no. of AUs
N2 = poissrnd(lambda2*area); % no. of IUs

p1 = unifrnd(-L,L,N1,2);
p2 = unifrnd(-L,L,N2,2);
% save( 'p1.mat', 'p1');
% save( 'p2.mat', 'p2');

% load p1.mat;
% load p2.mat;
% plot(p1(:,1),p1(:,2),'r*');
% hold on
% plot(p2(:,1),p2(:,2),'b+');
% voronoi(p1(:,1),p1(:,2));

p3 = unifrnd(-L,L,20,2);
% save( 'p3.mat', 'p3');
% 
% load p3.mat
% plot(p3(:,1),p3(:,2),'go');

[V,C] = voronoin(p1);

hasBS = zeros(length(p1),1);
BS = zeros(size(p1));

for i = 1:length(p1)
    if find(C{i,1}==1)
        continue
    end
    in = inpolygon(p3(:,1),p3(:,2),V(C{i,1},1),V(C{i,1},2));
    a = find(in==1);
    if isempty(a)
        continue
    end
    hasBS(i) = 1;    
    BS(i,:) = p3(a(1),:);
end
% save ('BS.mat', 'BS')
% save ('hasBS.mat','hasBS')
au = p1(logical(hasBS),:);
BS = BS(logical(hasBS),:); 

% save ('au.mat','au');
% save ('BS.mat', 'BS')
% 

clear V C in a p3
% plot(BS(logical(hasBS),1),BS(logical(hasBS),2),'go');




