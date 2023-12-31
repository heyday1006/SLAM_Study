function [mapUpdate, robPoseMapFrame, laserEndPntsMapFrame] = inv_sensor_model(map_set, map, scan, robPose, gridSize, offset, probOcc, probFree)
% Compute the log odds values that should be added to the map based on the inverse sensor model
% of a laser range finder.

% map is the matrix containing the occupancy values (IN LOG ODDS) of each cell in the map.
% scan is a laser scan made at this time step. Contains the range readings of each laser beam.
% robPose is the robot pose in the world coordinates frame.
% gridSize is the size of each grid in meters.
% offset = [offsetX; offsetY] is the offset that needs to be subtracted from a point
% when converting to map coordinates.
% probOcc is the probability that a cell is occupied by an obstacle given that a
% laser beam endpoint hit that cell.
% probFree is the probability that a cell is occupied given that a laser beam passed through it.

% mapUpdate is a matrix of the same size as map. It has the log odds values that need to be added for the cells
% affected by the current laser scan. All unaffected cells should be zeros.
% robPoseMapFrame is the pose of the robot in the map coordinates frame.
% laserEndPntsMapFrame are map coordinates of the endpoints of each laser beam (also used for visualization purposes).

% Initialize mapUpdate.
mapUpdate = zeros(size(map));

% Robot pose as a homogeneous transformation matrix.
robTrans = v2t(robPose);
% TODO: compute robPoseMapFrame. Use your world_to_map_coordinates implementation.
robPoseMapFrame = world_to_map_coordinates(robPose(1:2), gridSize, offset);
robPoseMapFrame(3) = robPose(3);
% Compute the Cartesian coordinates of the laser beam endpoints.
% Set the third argument to 'true' to use only half the beams for speeding up the algorithm when debugging.
laserEndPnts = robotlaser_as_cartesian(scan, 40, false);

% Compute the endpoints of the laser beams in the world coordinates frame.
laserEndPnts = robTrans*laserEndPnts;
% TODO: compute laserEndPntsMapFrame from laserEndPnts. Use your world_to_map_coordinates implementation.
laserEndPntsMapFrame = world_to_map_coordinates(laserEndPnts(1:2,:), gridSize, offset);
% Debug laser data
% figure(2)
% map_set = map_set/gridSize;
% for d = 1:size(map_set,2)
%     plot([map_set(1,d) map_set(3,d)]-offset(1)/gridSize,[map_set(2,d) map_set(4,d)]-offset(2)/gridSize,'k')
%     hold on
% end
% hold on
% plot(laserEndPntsMapFrame(1,:),laserEndPntsMapFrame(2,:),'rx')
% hold on
% plot(robPoseMapFrame(1),robPoseMapFrame(2),'bo')
% hold on
% freeCells are the map coordinates of the cells through which the laser beams pass.
freeCells = [];

% Iterate over each laser beam and compute freeCells.
% Use the bresenham method available to you in tools for computing the X and Y
% coordinates of the points that lie on a line.
% Example use for a line between points p1 and p2:
% [X,Y] = bresenham(map,[p1_x, p1_y; p2_x, p2_y]);
% You only need the X and Y outputs of this function.
for sc=1:size(laserEndPntsMapFrame,2)
        %TODO: compute the XY map coordinates of the free cells along the laser beam ending in laserEndPntsMapFrame(:,sc)
        [X,Y] = bresenham([robPoseMapFrame(1), robPoseMapFrame(2); laserEndPntsMapFrame(1,sc), laserEndPntsMapFrame(2,sc)]);

        %TODO: add them to freeCells
        freeCells = [freeCells, [X;Y]];

end
% figure(2)
% map_set = map_set/gridSize;
% for d = 1:size(map_set,2)
%     plot([map_set(1,d) map_set(3,d)]-offset(1)/gridSize,[map_set(2,d) map_set(4,d)]-offset(2)/gridSize,'k')
%     hold on
% end
% hold on
% plot(laserEndPntsMapFrame(1,:),laserEndPntsMapFrame(2,:),'rx')
% hold on
% plot(robPoseMapFrame(1),robPoseMapFrame(2),'bo')
% hold on
% plot(freeCells(1,:), freeCells(2,:), 'bo')
% hold off
%TODO: update the log odds values in mapUpdate for each free cell according to probFree.
for i=1:size(freeCells,2)
    mapUpdate(freeCells(1,i),freeCells(2,i)) = prob_to_log_odds(probFree);
end
%TODO: update the log odds values in mapUpdate for each laser endpoint according to probOcc.
for i=1:size(laserEndPntsMapFrame,2)
    mapUpdate(laserEndPntsMapFrame(1,i),laserEndPntsMapFrame(2,i)) = prob_to_log_odds(probOcc);
end

end
