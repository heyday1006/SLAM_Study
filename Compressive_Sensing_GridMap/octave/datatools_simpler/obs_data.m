function laser = obs_data()
    map = map_generation();
        figure(1)
    clf
    hold on
    for d = 1:size(map,2)
        plot([map(1,d) map(3,d)],[map(2,d) map(4,d)],'k')
    end
    hold on
    n_cell=10;                                      % Number of cells per meter 
    Ts = 1;                                         % Sampling time
    max_speed=4;                                    % max_speed*n_cell cm/timestep
    sigma_v = [0.01 0.01];                          % Standard deviation of sensor (Holds for up to 20m) (m)
    %sigma_v = [0.0 0.0]; 
    %Controller Parameters
    d = 1; 
    Kp = 0.4;
    Kh = 0.9;
    % LRS_Sensor Structure
    LRS.MaxDistance         = 4*n_cell;            % Maximum sensor measurement distance (m/10)
    LRS.Resolution          = 0.5;                  % Sensor resolution (degrees)
    LRS.FoV                 = 180;                  % Sensor field of view (degrees)
    LRS.MaxAngle            = 1.5773;               % extreme angle of laser scanner
    
    %% Second path generation 
    via = [100,35; 185,35; 185,40; 190,45; 195,50; 195,200; 190,205; 185,210; 180,215; 110,215; 105,195; 100,190; 95,185; ...
            95,170; 90,165; 85,160; 80, 155; 50,155; 45, 150; 40,145; 35,140; 35,110; 40,105; 45, 100; 50,95; 140,95; 145,100; ...
            150,105; 155,110; 155,140; 150,145; 145,150; 140,155; 50,155; 45, 150; 30,145; 35,140; 35,110; 40,105; ...
            45,100; 50,95; 80,95; 85,90; 90,85; 95,80; 95,35]; 
    %% Generation of a high order polynomial with the drive-through
    % points and a desired velocity as boundary conditions.
    path = mstraj(via,[max_speed, max_speed],[],[via(1,1) via(1,2)],Ts,0); 
    %Allocating sufficient space for the variables.
    Nsim = size(path,1);
    u = zeros(2,Nsim);
    x = zeros(3,Nsim);
    number_scanning = floor(LRS.FoV/LRS.Resolution)+1;
    scans = zeros(number_scanning, Nsim);
%     tic
%     h = timebar('Progress','Observation Simulation');  % Start timebar
    x(:,1) = [via(1,1),via(1,2),0];                     % Initialize robot pose at the start of the path.
    y = LaserScanNoise(x(:,1),map,LRS,sigma_v);  
    scans(:,1) = y(2,:);
    currentReading.poses = x(:,1);
    currentReading.ranges = scans(:,1)';
    currentReading.start_angle = y(1,1);
    currentReading.angular_resolution = LRS.Resolution*pi/180;
    currentReading.timestamp = 1;
    currentReading.maximum_range = LRS.MaxDistance;
    currentReading.laser_offset = [0 0 0]; 
    laser = [currentReading];
    plot(x(1,1), x(2,1),'ro');
    hold on
    plot(via(1,1),via(1,2),'rx')
    hold on
    for k = 2:size(path,1)
%         timebar(h, k/size(path,1))

        % True System
        % Compute Error Signals
            e = sqrt((path(k,1)-x(1,k-1))^2 + (path(k,2)-x(2,k-1))^2) - d;
            th = atan2((path(k,2)-x(2,k-1)),(path(k,1)-x(1,k-1)));
        % Control Signal
            u(1,k-1) = Kp*e;
            u(2,k-1) = Kh*(angdiff(th,x(3,k-1)));
        % Kinematics
            x(:,k) = kinematics(x(:,k-1),u(:,k-1));
        % True LRS data
            y = LaserScanNoise(x(:,k),map,LRS,sigma_v);  
            scans(:,k) = y(2,:);
            currentReading.poses = x(:,k);
            currentReading.ranges = scans(:,k)';
            currentReading.start_angle = y(1,1);
            currentReading.angular_resolution = LRS.Resolution*pi/180;
            currentReading.timestamp = k;
            currentReading.maximum_range = LRS.MaxDistance;
            currentReading.laser_offset = [0 0 0]; 
            laser = [laser currentReading];
            plot(x(1,k), x(2,k), 'ro');
            hold on
            plot(path(k,1),path(k,2),'rx')
    end
         
%  
    hold off
%     close all
%     laser = cell2mat(laser);
%     toc
%     close(h)