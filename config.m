% Isaac Parker
% 8/24/2026 - v01
% Configuration file for lsqnonlin fit variables

clear

% Sample properties and experimental parameters ---------------------------
% Film properties
Kf = 24;         % thermal conductivity (W/m/K)
Df = 15.1E-06;   % thermal diffusivity (m^2/s)
Cf = Kf/Df;      % volumetric heat capacity (J/m^3/K)
af = 3.4385E+07; % optical absorption coefficient (1/m)
Rf = 0.32;       % optical reflectivity, R in [0,1]
hf = 2e-6;       % thickness (m)


% Substrate properties
Ks = 60.7;       % thermal conductivity (W/m/K)
Ds = 14.9E-06;   % thermal diffusivity (m^2/s)
Cs = Ks/Ds;      % volumetric heat capacity (J/m^3/K)
as = 8.2547E+07; % optical absorption coefficient (1/m)
Rs = 0.63;       % optical reflectivity
hs = 1.5e-3;     % thickness (m)


% Heat source properties
lzang = deg2rad(125); % laser angle with the x-axis
ry = 100E-06; % laser radius in y direction (m)
rx = 122E-06; % laser radius in x-direction due to lzang
P = 150e-3; % laser power (W)
f = 19; % modulation frequency (Hz)


% Thermal contact resistance
Rth = 0;
% End of sample properties and experimental parameters --------------------


% Consolidate properties into arrays and save variables -------------------
% Thermal conductivity tensors (isotropic configuration)
K = [Kf,Ks;
      0, 0;
      0, 0;
     Kf,Ks;
      0, 0;
     Kf,Ks];


% Film-substrate property arrays
C = [Cf,Cs];
a = [af,as];
R = [Rf,Rs];
h = [hf,hs];


% Laser radius array
r = [rx, ry];

% Offset
offset = -50;

% Save, clear, and reload properties
save("config.mat","K","C","a","R","h","r","P","f","Rth","offset")
% End of consolidate properties -------------------------------------------


% Load data
file = "data.mat";
data = load(fullfile("data",file));
% phaseinterp = scatteredInterpolant(data.X,data.Y,data.phase);
% maginterp = scatteredInterpolant(data.X,data.Y,data.amp);


save("config.mat", "data","-append");