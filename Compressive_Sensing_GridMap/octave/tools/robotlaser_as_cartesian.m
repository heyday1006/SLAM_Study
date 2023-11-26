function points = robotlaser_as_cartesian(rl, maxRange, subsample)
if nargin<3
    subsample = false;
end
if nargin<2
    maxRange = 15;
end
numBeams = length(rl.ranges);
maxRange=min(maxRange, rl.maximum_range);
% apply the max range
idx = rl.ranges<maxRange & rl.ranges>0;

if (subsample)
	idx(2:2:end) = 0;
end

angles_set = linspace(rl.start_angle, rl.start_angle + numBeams*rl.angular_resolution, numBeams);
angles = angles_set(idx);
points = [rl.ranges(idx) .* cos(angles); rl.ranges(idx) .* sin(angles); ones(1, length(angles))];
transf = v2t(rl.laser_offset);

% apply the laser offset
points = transf * points;

end
