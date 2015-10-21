%lambda = lambda1/lambda2;

rho2 = zeros(6,1);

eps1 = @(psi,lambda) 2*((cos(psi)).^2)./(pi*(lambda+4*((cos(psi)).^2)));
eps2 = 1/(3*(lambda+1));
Lambda = [1,1/2,1/4,1/8,1/16,1/32];
for i = 1:6
    lambda = Lambda(i);
    rho2(i) =  integral(@(psi)eps1(psi,lambda),-pi/2,-pi/3) + integral(@(psi)eps1(psi,lambda),pi/3,pi/2) + eps2;
end
plot(1./Lambda,rho2)

