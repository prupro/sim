%lambda = lambda1/lambda2;

rho2 = zeros(6,1);
gamma = 3;
eps1 = @(psi,lambda) 2*((cos(psi)).^2)./(pi*(lambda + 4*((cos(psi)).^2)));
eps2 = @(lambda) 1/(3*(lambda+1));
Lambda = [1,1/2,1/4,1/8,1/12,1/16,1/20,1/24,1/28,1/32];
for i = 1:10
    lambda = Lambda(i);
    rho2(i) =  integral(@(psi)eps1(psi,lambda),-pi/2,-pi/3) + integral(@(psi)eps1(psi,lambda),pi/3,pi/2) + eps2(lambda);
end
plot(1./Lambda,rho2)

