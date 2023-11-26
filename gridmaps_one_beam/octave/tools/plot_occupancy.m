function plot_occupancy(map_set,gridSize,offset,laserEndPntsMapFrame,robPoseMapFrame,mapUpdate,log_odds_Free)
%     figure(2)
    
    map_set = map_set/gridSize;
    for d = 1:size(map_set,2)
        plot([map_set(1,d) map_set(3,d)]-offset(1)/gridSize,[map_set(2,d) map_set(4,d)]-offset(2)/gridSize,'k')
        hold on
    end
    plot(laserEndPntsMapFrame(1,:),laserEndPntsMapFrame(2,:),'rx')
    hold on
    plot(robPoseMapFrame(1),robPoseMapFrame(2),'bo')
    hold on
    [freeCellsx,freeCellsy] =  ind2sub([size(mapUpdate,1) size(mapUpdate,2)],find(mapUpdate == log_odds_Free));
    plot(freeCellsx, freeCellsy, 'bo')
    set(gca, 'YDir','reverse')
    hold off