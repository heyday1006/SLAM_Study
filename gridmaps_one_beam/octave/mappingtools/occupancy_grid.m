function [map, mapUpdate, robPoseMapFrame, laserEndPntsMapFrame] = occupancy_grid(map_set, map, sc, robPose, gridSize, offset, probOcc, probFree, logOddsPrior)
    [mapUpdate, robPoseMapFrame, laserEndPntsMapFrame] = inv_sensor_model(map_set, map, sc, robPose, gridSize, offset, probOcc, probFree);

	mapUpdate = mapUpdate - logOddsPrior*ones(size(map));
	% Update the occupancy values of the affected cells.
	map = map + mapUpdate;
    
end