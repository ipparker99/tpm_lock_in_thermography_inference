function [Kiso_crit, offset_crit] = fit_k(vars, data, x0)
% x0(1)--substrate thermal conductivity
% x0(2)--offset

disp("Fit substrate thermal conductivity and offset")
disp("Initial substrate thermal conductivity: " + x0(1) + " W/m/K")

% lsq set up
% anonymous function
% x(1) is Kiso and x(2) is offset
fun = @(x) res(x(1), x(2), vars.K(:,1), vars.C, vars.a, vars.R, vars.h, ...
    vars.Rth,vars.r,vars.P,vars.f, data);


% initial thermal conductivity and bounds
lb = [0,-180];
ub = [400,180];


% call lsqnonlin
[x_crit,~] = lsqnonlin(fun, x0, lb, ub);

Kiso_crit = x_crit(1);
offset_crit = x_crit(2);

disp("Best fit substrate thermal conductivity: " + Kiso_crit...
    + " W/m/K" + newline)


function f = res(Kiso, offset, Kf, C, a, R, h, Rth, r, P, f, data)
    
    % Organize thermal conductivity array
    Ks = [Kiso, 0, 0, Kiso, 0, Kiso].'; % (6,1)
    K = [Kf,Ks]; % (6,2)
    
    % Compute T0hat(U,V)
    [X,Y,phase_model,~] = Calc_T0(K(1,1),K(2,1),K(3,1),K(4,1),K(5,1),K(6,1),...
        C(1),a(1),R(1),h(1),K(1,2),K(2,2),K(3,2),K(4,2),K(5,2),K(6,2),...
        C(2),a(2),R(2),h(2),Rth,r(1),r(2),P,f);
    
    % Scattered interpolant
    phase_model_interp = scatteredInterpolant(X, Y, phase_model);
    phase_pred = phase_model_interp(data.X, data.Y) + offset;
    
    if isempty(phase_pred)
    warning("fm returned empty array")
    end

    % difference between model and data
    f = data.phase - phase_pred;
end
end