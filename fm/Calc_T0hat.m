function T0hat = Calc_T0hat(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,af,Rf,hf,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,as,Rs,hs,Rth,rx,ry,P,f0,u,v)
% Compute T0hat(U,V)


Lth = sqrt(Ks11 / (Cs*pi*f0));

    if hs > 3 * Lth
        T0hat = T0hat_infinite(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,af,Rf,hf,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,as,Rs,hs,Rth,rx,ry,P,f0,u,v);
    else
        T0hat = T0hat_finite(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,af,Rf,hf,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,as,Rs,hs,Rth,rx,ry,P,f0,u,v);
    end
end