% Isaac Parker
% 2026-04-30 - Modified from python script using claude ai
%
% Description: Visualize lock-in thermography data. 
% 1. Read in tiff images of amplitude and phase from Box drive
% 2. Find the heating center by analyzing the amplitude image.
% 3. Map the pixels to positions relative to the heating center
% 4. Save data to .mat files

clear
clc


% Read in amplitude data image
amp = imread("amp_19hz_23C.tiff");
amp = double(amp);
amp = flipud(amp);


% Read in phase angle data image
phase = imread("phase_19hz_23C.tiff");
phase = double(phase);
phase     = flipud(phase);
phase     = -1 * phase; % phase angle should be negative and continue to 
                    % decrease with distance from the heating center


% Find max row and max column
[~, cy] = max(sum(amp, 2)); % find row with most amplitude
[~, cx] = max(sum(amp, 1)); % find column with most amplitude


% Map indices to positions relative to the heating center
[nrows, ncols] = size(amp);
dx = 15e-6;  % pixel pitch (m)
x  = ((1:ncols) - cx) * dx;  % (m)
y  = ((1:nrows) - cy) * dx;  % (m)


% meshgrid
[X, Y] = meshgrid(x, y);


% Crop to circle within thresh of center point
thresh = 0.35e-3;
idx = X.^2 + Y.^2 < thresh^2;
X = X(idx);
Y = Y(idx);
phase = phase(idx);
amp = amp(idx);

% Convert rad to deg
phase = rad2deg(phase);


% display amplitude data
figure(1);
clf
scatter3(X,Y,amp,20,amp,"filled");
colorbar
xlabel("X")
ylabel("Y")
zlabel('Amplitude');
fontsize(18,"points")
savefig("amp.fig")


% display phase data
figure(2)
clf
scatter3(X,Y,phase,20,phase,"filled")
colorbar
xlabel("X")
ylabel("Y")
zlabel('Phase angle (deg)');
fontsize(18,"points")
savefig("phase.fig")


% Save data to .mat file
save("data.mat","X","Y","phase","amp")