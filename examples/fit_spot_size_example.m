% Least squares fit for heat spot size using synthetic magnitude data
clear

% data fm to path
addpath("fm")

% Load config file
vars = load("config.mat");
data = vars.data;

% initial spot size
r0 = [500e-6, 200e-6];

% Fit spot size
r_crit = fit_spot_size(vars, r0);


% Diagnostics
% obtained optimized amalytical results
[X,Y,phase,amp_model] = Calc_T0(vars.K(1,1),vars.K(2,1),vars.K(3,1),...
    vars.K(4,1),vars.K(5,1),vars.K(6,1),vars.C(1),vars.a(1),vars.R(1),...
    vars.h(1),vars.K(1,2),vars.K(2,2),vars.K(3,2),vars.K(4,2),...
    vars.K(5,2),vars.K(6,2),vars.C(2),vars.a(2),vars.R(2),vars.h(2),...
    vars.Rth,r_crit(1),r_crit(2),vars.P,vars.f);


% scale predicted amplitude
scale(1) = 1 / max(amp_model, [], "all");
amp_model = scale(1) * amp_model;
amp_model_interp = scatteredInterpolant(X, Y, amp_model);

% scale observed amplitude
scale(2) = 1 / max(data.amp, [], "all");
data.amp = scale(2) * data.amp;

% get difference
residual_amp = data.amp - amp_model_interp(data.X, data.Y);

% Display analytical amplitude
figure(1)
clf
hold on
scatter3(data.X, data.Y, residual_amp, 20, residual_amp,'filled')
xlabel("X (m)")
ylabel("Y (m)")
zlabel("Residual observed minus predicted")
colorbar
fontsize(18,"points")

% Plot heating spot outline
theta = linspace(0, 2*pi, 200);
spotX = r_crit(1) * cos(theta);
spotY = r_crit(2) * sin(theta);
plot3(spotX, spotY, zeros(size(spotX)))

% Display parity
figure(2)
clf
hold on
plot(data.amp, amp_model_interp(data.X, data.Y), '.')
plot([0,1],[0,1])
xlabel("Observed Amplitude")
ylabel("Predicted Amplitude")
fontsize(18, "points")

% Display observed amplitude
figure(3)
clf
hold on
scatter3(data.X, data.Y,data.amp, 20, data.amp, 'filled')
xlabel("X (m)")
ylabel("Y (m)")
zlabel("Amplitude")
colorbar
fontsize(18,"points")
plot3(spotX, spotY, zeros(size(spotX)))