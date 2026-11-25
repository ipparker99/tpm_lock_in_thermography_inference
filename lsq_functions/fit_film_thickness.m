function hf_crit = fit_film_thickness(vars, data, x0)
% x0(1)--film thermal conductivity
% x0(2)--film thickness

disp("Fitting film thickness")
disp("Initial film thickness: " + x0 + " m")

% lsq set up
% anonymous function
% x(1) is h(1) the film thickness and x(2) is kf
fun = @(x0) res(vars.K(:,1), vars.K(:,2), vars.C, vars.a, vars.R, [x0, vars.h(2)], ...
    vars.Rth,vars.r,vars.P,vars.f, data, vars.offset);

% initial thermal conductivity and bounds
lb = 1E-07;
ub = 1E-03;

% call lsqnonlin
[hf_crit,~] = lsqnonlin(fun, x0, lb, ub);

disp("Best fit film thickness: " + hf_crit + " m" + newline)

function f = res(Kf, Ks, C, a, R, h, Rth, r, P, f, data, offset)
    
    K = [Kf, Ks];

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