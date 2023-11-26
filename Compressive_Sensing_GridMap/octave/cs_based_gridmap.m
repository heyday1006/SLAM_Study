% close all
% clear all

function cs_based_gridmap(csFlag, csPercent)

addpath('tools')
addpath('cstools')
addpath('datatools')
addpath('mappingtools')
more off

csFlag = false;
cs_percent = 0.8;
if nargin > 1
    csFlag = true;
    cs_percent = csPercent;
end

% Load laser scans and robot poses.
%load("../data/laser")
laser = obs_data();
map_set = map_generation();
% Extract robot poses: Nx3 matrix where each row is in the form: [x y theta]
poses = [laser.poses]';

% Initial cell occupancy probability.
prior = 0.50;
% Probabilities related to the laser range finder sensor model.
probOcc = 0.9;
probFree = 0.35;

% Map grid size in meters. Decrease for better resolution.
gridSize = 0.5;

% Set up map boundaries and initialize map.
border = 40;
robXMin = min(poses(:,1));
robXMax = max(poses(:,1));
robYMin = min(poses(:,2));
robYMax = max(poses(:,2));
mapBox = [robXMin-border robXMax+border robYMin-border robYMax+border];
offsetX = mapBox(1);
offsetY = mapBox(3);
mapSizeMeters = [mapBox(2)-offsetX mapBox(4)-offsetY];
mapSize = ceil([mapSizeMeters/gridSize]);
% Used when updating the map. Assumes that prob_to_log_odds.m
% has been implemented correctly.
logOddsPrior = prob_to_log_odds(prior);

% The occupancy value of each cell in the map is initialized with the prior.
map = logOddsPrior*ones(mapSize);
% map = logOddsPrior*ones(xg,yg);
%map = 0.5*ones(xg,yg);
disp('Map initialized. Map size:'), disp(size(map))

% Map offset used when converting from world to map coordinates.
offset = [offsetX; offsetY];

if csFlag
    % compression level
%     cs_percent = 0.5;
    scan = laser(1,1);
    theta_pointer = cs_pointer(scan.ranges, cs_percent);
end
% Main loop for updating map cells.
% You can also take every other point when debugging to speed up the loop (t=1:2:size(poses,1))
for(t=1:size(poses,1))
    t
	% Robot pose at time t.
	robPose = [poses(t,1);poses(t,2);poses(t,3)];
	
	% Laser scan made at time t.
	sc = laser(1,t);
    if csFlag
        ranges_old = sc.ranges;
        % 0 is no noise, 1 is with noise and noise level set to 0.01
        sc.ranges = cs_reconstruction_noise(sc.ranges, theta_pointer, 0, 0.01);
        % check laser reconstruction results
        %cs_plot(ranges_old, sc.ranges, cs_percent, theta_pointer)
    end
	% Update map grids
    [map, mapUpdate,robPoseMapFrame, laserEndPntsMapFrame] = occupancy_grid(map_set, map, sc, robPose, gridSize, offset, probOcc, probFree, logOddsPrior);

	% Plot current map and robot trajectory so far.
    
%     subplot(1,2,1)
%     % check occupancy at each step
%     plot_occupancy(map_set,gridSize,offset,laserEndPntsMapFrame,robPoseMapFrame,mapUpdate,prob_to_log_odds(probFree));
%     axis square
%     subplot(1,2,2)
    figure(1)
    plot_map(map, map_set, mapBox, robPoseMapFrame, poses, laserEndPntsMapFrame, gridSize, offset, t);
    axis square
    hold on
    if csFlag
        sgtitle(sprintf("compression level %.2f", cs_percent));
    else
        sgtitle(sprintf("compression level %.2f", 100));
    end
end

