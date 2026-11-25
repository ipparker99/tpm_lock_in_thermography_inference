% Nonlinear least squares applied in series
clear

% configuration script
addpath("fm")
addpath("lsq_functions")

% Load config file
vars = load("config.mat");
data = vars.data;


% Fit several parameters again
Kf_0 = vars.K(1, 1); % W/m/K
Ks_0 = vars.K(1, 2); % W/m/K
hf_0 = vars.h(1); % m
r_0 = vars.r; % m
offset_0 = vars.offset; % deg
x0 = [Kf_0, Ks_0, hf_0, r_0, offset_0];

x_crit = lsq_fit(vars, data, x0);

Kf_crit = x_crit(1);
Ks_crit = x_crit(2);
hf_crit = x_crit(3);
r_crit = x_crit(4:5);
offset_crit = x_crit(6);

% Update vars
vars.K(:,1) = [Kf_crit, 0, 0, Kf_crit, 0, Kf_crit].';
vars.K(:,2) = [Ks_crit, 0, 0, Ks_crit, 0, Ks_crit].';
vars.h(1) = hf_crit;
vars.r = r_crit;
vars.offset = offset_crit;

diagnose(vars, data)

function [] = diagnose(vars, data)
    % run forward model
    [X,Y,phase_model,amp] = Calc_T0(vars.K(1,1), vars.K(2,1), vars.K(3,1),...
        vars.K(4,1), vars.K(5,1), vars.K(6,1), vars.C(1),vars.a(1),vars.R(1),...
        vars.h(1),vars.K(1,2),vars.K(2,2),vars.K(3,2),vars.K(4,2),...
        vars.K(5,2),vars.K(6,2),vars.C(2),vars.a(2),vars.R(2),vars.h(2),...
        vars.Rth,vars.r(1),vars.r(2),vars.P,vars.f);
    
    % Display observed phase
    figure(1)
    clf
    hold on
    scatter3(data.X*1E+06, data.Y*1E+06, data.phase, 35, data.phase, 'filled')
    xlabel("X (um)")
    ylabel("Y (um)")
    zlabel("Phase (deg)")
    colorbar
    fontsize(16,"points")

    % Scattered interpolant
    phase_model_interp = scatteredInterpolant(X, Y, phase_model);
    phase_pred = phase_model_interp(data.X, data.Y) + vars.offset;
    
    % get difference
    residual_phase = data.phase - phase_pred;
    
    % Display residual phase
    figure(2)
    clf
    hold on
    scatter3(data.X, data.Y, residual_phase, 20, residual_phase,'filled')
    xlabel("X (m)")
    ylabel("Y (m)")
    zlabel("Residual observed minus predicted")
    colorbar
    fontsize(18,"points")
    
    % Display parity
    figure(3)
    clf
    hold on
    plot(data.phase, phase_pred, '.')
    plot([-200,-120],[-200,-120])
    xlabel("Observed Phase")
    ylabel("Predicted Phase")
    fontsize(18, "points")
end

[X,Y,phase_model,amp] = Calc_T0(vars.K(1,1), vars.K(2,1), vars.K(3,1),...
        vars.K(4,1), vars.K(5,1), vars.K(6,1), vars.C(1),vars.a(1),vars.R(1),...
        vars.h(1),vars.K(1,2),vars.K(2,2),vars.K(3,2),vars.K(4,2),...
        vars.K(5,2),vars.K(6,2),vars.C(2),vars.a(2),vars.R(2),vars.h(2),...
        vars.Rth,vars.r(1),vars.r(2),vars.P,vars.f);

% Plot residual vs. fitted value
% Scattered interpolant
phase_model_interp = scatteredInterpolant(X, Y, phase_model);
phase_pred = phase_model_interp(data.X, data.Y) + vars.offset;

% get difference
residual_phase = data.phase - phase_pred;

% Display residual phase
figure(4)
clf
hold on
plot(phase_pred, residual_phase,'.')
xlabel("Predicted phase (deg)")
ylabel("Residual (deg), observed minus predicted")
fontsize(18,"points")