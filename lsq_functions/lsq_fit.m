function x_crit = lsq_fit(vars, data, x0)
% x0(1)--substrate thermal conductivity
% x0(2)--offset

disp("Fit substrate thermal conductivity and offset")
disp("Initial substrate thermal conductivity: " + x0(2) + " W/m/K")

% lsq set up
% anonymous function
% x(1) is Kf
% x(2) is Ks
% x(3) is h(1)
% x(4) is r(1)
% x(5) is r(2)
% x(6) is offset
fun = @(x) res(x(1), x(2), vars.C, vars.a, vars.R, [x(3), vars.h(2)], ...
    vars.Rth, x(4:5), vars.P, vars.f, x(6), data);

% initial thermal conductivity and bounds
lb = [0, 0, 1e-7, 1e-7, 1e-7,-180];
ub = [400, 400, 1e-3, 1e-3, 1e-3, 180];

% call lsqnonlin
[x_crit,~] = lsqnonlin(fun, x0, lb, ub);

disp("Best fit substrate thermal conductivity: " + x_crit(2) + " W/m/K")

function f = res(Kf, Ks, C, a, R, h, Rth, r, P, f, offset, data)

    % Organize thermal conductivity array
    Kf = [Kf, 0, 0, Kf, 0, Kf].';
    Ks = [Ks, 0, 0, Ks, 0, Ks].'; % (6,1)
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