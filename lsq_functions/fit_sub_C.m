function x_crit = fit_sub_C(vars, data, x0)
% x0(1)--film thermal conductivity
% x0(2)--film thickness

disp("Fitting substrate volumetric heat capacity")
disp("Initial substrate volumetric heat capacity: " + x0(1) + " J/m^3")

% lsq set up
% x0(1) is vars.C(2) the volumetric heat capacity of the substrate
% x0(2) is the phase offset
% x(1) is substrate volumetric heat capacity the film thickness and x(2) is kf
fun = @(x0) res(vars.K, [vars.C(1), x0(1)], vars.a, vars.R, vars.h, ...
    vars.Rth, vars.r, vars.P, vars.f, data, x0(2));

% ounds
lb = [0, -180];
ub = [1E+07, 180];

% call lsqnonlin
x_crit = lsqnonlin(fun, x0, lb, ub);
disp("Best fit substrate volumetric heat capacity: " + x_crit(1)...
    + " J/m^3" + newline)

function f = res(K, C, a, R, h, Rth, r, P, f, data, offset)
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