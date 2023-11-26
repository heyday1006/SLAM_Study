function plot_map(map, map_set, mapBox, robPoseMapFrame, poses, laserEndPntsMapFrame, gridSize, offset, t)

%  	close all
%  	figure 
%     f = figure("visible", "on");
% figure(1)
%     set(gcf,'units','normalized','outerposition',[1 0 1 1]);
% % 	axis(mapBox);
%     clf
    
	map = map';
	imagesc((ones(size(map)) - log_odds_to_prob(map)))
    colormap gray;
    caxis([0, 1]);
    hold on
    map_set = map_set/gridSize;
    for d = 1:size(map_set,2)
        plot([map_set(1,d) map_set(3,d)]-offset(1)/gridSize,[map_set(2,d) map_set(4,d)]-offset(2)/gridSize,'k')
    end
    %axis image
    hold on;
	traj = [poses(1:t,1)';poses(1:t,2)'];
	traj = world_to_map_coordinates(traj, gridSize, offset);
	plot(traj(1,:),traj(2,:),'g')
    grid on
    hold on;
	plot(robPoseMapFrame(1),robPoseMapFrame(2),'bo','markersize',5,'linewidth',4)
	hold on;
    plot(laserEndPntsMapFrame(1,:),laserEndPntsMapFrame(2,:),'ro','markersize',2)
    	filename = sprintf('../plots/gridmap_%03d.png', t);
	print(filename, '-dpng');
    hold off;
	%close all;
%         figure(3)
%         set(gcf,'units','normalized','outerposition',[1 0 1 1]);
%         clf    
%         imagesc(flipud(ones(size(map)) - log_odds_to_prob(map)));
%         caxis([0, 1]);
%         colormap gray;
%         colormap(flipud(colormap));
%         hold on;
%         grid on;
%         plot(robPoseMapFrame(1),robPoseMapFrame(2), 'dr');

end
