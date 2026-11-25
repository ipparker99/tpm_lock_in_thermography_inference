clear

% configuration script
addpath("fm")

% Load config file
vars = load("config.mat");
data = vars.data;
vars.offset = -120; % Value for model phase offset

% initial film thermal conductivity
Kf_0 = vars.K(1,1); % intitial guess for film thermal conductivity W/m-K
hf_0 = vars.h(1); % intitial guess for film thickness

% call fit_film
Kf_crit = fit_film_k(vars, data, Kf_0);

% Organize thermal conductivity array
Kf = [Kf_crit, 0, 0, Kf_crit, 0, Kf_crit].'; % (6,1)
K = [Kf, vars.K(:,2)]; % (6,2)

% obtain optimized amalytical results
[X,Y,phase_model,amp] = Calc_T0(K(1,1),K(2,1),K(3,1),...
    K(4,1),K(5,1),K(6,1),vars.C(1),vars.a(1),vars.R(1),...
    vars.h(1),vars.K(1,2),vars.K(2,2),vars.K(3,2),vars.K(4,2),...
    vars.K(5,2),vars.K(6,2),vars.C(2),vars.a(2),vars.R(2),vars.h(2),...
    vars.Rth,vars.r(1),vars.r(2),vars.P,vars.f);

% Diagnostics
% Scattered interpolant
phase_model_interp = scatteredInterpolant(X, Y, phase_model);
phase_pred = phase_model_interp(data.X, data.Y) + vars.offset;

% get difference
residual_phase = data.phase - phase_pred;

% Display residual phase
figure(1)
clf
hold on
scatter3(data.X, data.Y, residual_phase, 20, residual_phase,'filled')
xlabel("X (m)")
ylabel("Y (m)")
zlabel("Residual observed minus predicted")
colorbar
fontsize(18,"points")

% Display parity
figure(2)
clf
hold on
plot(data.phase, phase_pred, '.')
plot([-200,-120],[-200,-120])
xlabel("Observed Phase")
ylabel("Predicted Phase")
fontsize(18, "points")

% Display observed phase
figure(3)
clf
hold on
scatter3(data.X, data.Y,data.phase, 20, data.phase, 'filled')
xlabel("X (m)")
ylabel("Y (m)")
zlabel("Phase")
colorbar
fontsize(18,"points")