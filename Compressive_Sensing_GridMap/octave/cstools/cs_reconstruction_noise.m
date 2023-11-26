function y_recon = cs_reconstruction_noise(x, theta_pointer, noise, epsilon)
% x: range-and-bearing measurement
% theta_pointer: sensing matrix indices-- subset of identity matrix
% y = Theta * x gives sampled measurements
% x_recon: reconstructed x

% D: finite difference operator
D = cs_createFiniteDiff2(numel(x));
% identity matrix
I = eye(numel(x));
% sensing matrix
Theta = I(theta_pointer,:);
% sampled measurements
y = Theta * x'; 
% solve l1-minimization
% [f, z] = Basis_Pursuit(y,D,Theta);
switch noise
    case 0
        cvx_begin quiet
        variables z(numel(x)) 
            minimize(norm(D*z,1))
            subject to
            y == Theta * z;
        cvx_end
    case 1
        cvx_begin quiet
        variables z(numel(x)) 
            minimize(norm(D*z,1))
            subject to
            norm(Theta * z - y, inf) <= epsilon;
        cvx_end
end
        
f = norm(D * z, 1);

% populate a vector of signs 
s = zeros(numel(x),1);
% % find twin samples
for m = 1:(numel(theta_pointer)-2)/2-1
    i = theta_pointer(2 * m);
    j = i + 2;
    for k = (i+2:j-1)
        s(k) = sign((z(j+1) - z(j)) - (z(i+1) - z(i)));
    end
end
    
% recover depth within the solution set
switch noise
    case 0
        cvx_begin quiet
            variables zo(numel(x)) 
                minimize(norm(s'*zo,1))
                subject to
                y == Theta * zo;
                norm(D*zo,1) <= f;
        cvx_end
    case 1
        cvx_begin quiet
            variables zo(numel(x)) 
                minimize(norm(s'*zo,1))
                subject to
                norm(Theta * zo - y, inf) <= epsilon;
                norm(D*zo,1) <= f;
        cvx_end
end
y_recon = zo';
% q=[p;p+1];
% theta_pointer(q)   
% find consecutive twin samples
