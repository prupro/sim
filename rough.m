p1 = [0,0;1,0;0,1;-1,0;0,-1];

plot(p1(:,1),p1(:,2),'r*');
hold on
voronoi(p1(:,1),p1(:,2));

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
save BS
save hasBS

clear V C in a
plot(BS(:,1),BS(:,2),'go');

plot(r2byr1(hasCoop ~= 0),assistedRate(hasCoop~=0)./rate(hasCoop~=0),'ro');


lambda = 1/2;
eps1 = @(psi,lambda) 2*((cos(psi)).^2)./(pi*(lambda+4*((cos(psi)).^2)));

a = integral(@(psi)eps1(psi,lambda),-pi/2,pi/2)
gamma = 3;
fz = @(z) (gamma*(z.^(gamma-1)))./((1+z.^gamma).^2);
b = integral(fz,2,Inf)

fz = @(x,y)fx(x).*fy(y);
integral2(fz,0,4,2,ymax)


