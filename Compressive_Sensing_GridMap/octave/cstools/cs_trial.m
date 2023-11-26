% Created on 07/12/2020
% Test the function in comp_reconstruction.m referring to Karaman's
% compressive sensing reconstruction algorithem (exact recovery)
fpiece = @(x) min(0.5.*x, 5-0.125.*x);
ranges = fpiece([0:40/180:40]);
% ranges = (1:10);
cs_percent = 0.2;
% scan = laser(1,1);
cs_level = floor(numel(ranges) * cs_percent);
cs_level = cs_level + 1 - rem(cs_level,2); % even number
% random selection of identity matrix for compression
%pointer = randperm(numel(ranges)-2,cs_level-2)+1; %m-2 samples from 2 to n-1
% pointer = [];
% ranges_idx = (2:numel(ranges)-1);
% for i = 1:(cs_level-2)/2
%     idx = randi(numel(ranges_idx)-1);
%     pointer = [pointer ranges_idx(idx:idx+1)];
%     ranges_idx = [ranges_idx(1:idx-1) ranges_idx(idx+2:end)];
% end
% theta_pointer = [1 sort(pointer) numel(ranges)];
theta_pointer = cs_pointer(ranges, cs_percent);
ranges_new = cs_reconstruction_noise(ranges, theta_pointer, 0, 0.05);
cs_plot(ranges, ranges_new, cs_percent, theta_pointer)
% figure
% plot(ranges,'-rx','MarkerSize',12);
% hold on
% plot(ranges_new,'-bo');
% legend('original','reconstructed')
% xlabel('bearing')
% ylabel('range')
% title(sprintf("compression level %.2f", cs_percent));
% hold off