function r_crit = fit_spot_size(vars, r0)
% Least squares fit for heat spot size using synthetic magnitude data

disp("Fitting spot size to amplitude data")
disp("Intial spot sizes: "+r0(1) + ", " + r0(2) + " m")

data = vars.data;
% lsq set up
% anonymous function
fun = @(r) res(r, vars.K, vars.C, vars.a, vars.R, vars.h, ...
    vars.Rth, vars.P, vars.f, data);


% bounds
lb = [0,0];
ub = [800e-6,800e-6];


% call lsqnonlin
[r_crit,~] = lsqnonlin(fun,r0,lb,ub);

disp("Best fit spot sizes: " + r_crit(1) + ", " + r_crit(2) + " m" + newline)

function f = res(r,K,C,a,R,h,Rth,P,f,data)

    % Compute T0hat(U,V)
    [X,Y,~,amp_model] = Calc_T0(K(1,1),K(2,1),K(3,1),K(4,1),K(5,1),K(6,1),...
        C(1),a(1),R(1),h(1),K(1,2),K(2,2),K(3,2),K(4,2),K(5,2),K(6,2),...
        C(2),a(2),R(2),h(2),Rth,r(1),r(2),P,f);
    
    
    % Scaling
    scale(1) = 1 / max(amp_model,[],"all");
    amp_model = scale(1) * amp_model;
    
    scale(2) = 1 / max(data.amp,[],"all");
    data.amp = scale(2) * data.amp;
    
    % Scatter interpolant
    amp_model_interp = scatteredInterpolant(X,Y,amp_model);
    
    % difference between model and data
    f = amp_model_interp(data.X, data.Y) - data.amp;
end
end