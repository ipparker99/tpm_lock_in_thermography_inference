function [X,Y,phase,mag] = Calc_T0(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,af,Rf,hf,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,as,Rs,hs,Rth,rx,ry,P,f0)


    % Grid set up
    Lth = sqrt(Ks11 / (Cs*pi*f0));
    x_max = 30*Lth;
    Nx = 2^10;
    [dx,X,Y,U,V] = build_grid(x_max,Nx);
    
    
    % Compute T0hat(U,V)
    T0hat = Calc_T0hat(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,af,Rf,hf,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,as,Rs,hs,Rth,rx,ry,P,f0,U,V);
    
    % Convert T0hat(U,V) -> T0(X,Y)
    [X,Y,phase,mag] = T0hat_to_T0(X,Y,dx,Lth,T0hat);
end