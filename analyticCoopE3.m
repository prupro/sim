rho3 = zeros(10,1);
gamma = 3;
fz = @(z) (gamma*(z.^(gamma-1)))./((1+z.^gamma).^2);
eps1 = @(psi,lambda) 2*((cos(psi)).^2)./(pi*(lambda+4*((cos(psi)).^2)));

psimax = @(z) -acos(z/2);
psimin = @(z) acos(z/2);


eps2 = @(z,lambda) (acos(z/2).*(z.^2))./(pi*(lambda+z.^2));
%eps2 = @(z,lambda) (acos(z/2))./(pi*(lambda+1));
Lambda = [1,1/2,1/4,1/8,1/12,1/16,1/20,1/24,1/28,1/32];
for i = 1:10
    lambda = Lambda(i);
    t = @(z,psi)fz(z).*eps1(psi,lambda);
    t1 = integral2(t,0,2,-pi/2,psimax);
    t2 = integral2(t,0,2,psimin,pi/2);
   % t3 = integral(@(z)eps2(z).*(2*acos(z/2)),0,2);
    t3 = integral(@(z) eps2(z,lambda).*fz(z),0,2);
    t4=integral(@(psi)eps1(psi,lambda),-pi/2,pi/2)*integral(fz,2,Inf);

    rho3(i) =  t1+t2+t3+t4;
end
plot(1./Lambda,rho3,'r')





