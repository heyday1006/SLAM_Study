%this file read the .mat which copies the data from .pickle
%then it visualizes the scan matching, which validates the 
%correct value of relative pose
load('./pos_rels.mat')
pose_rels=data_rels(1,:,:);
load('./range_pairs.mat')
range_pairs=data_rels(1,:,:,:);

ranges=[];
poses=[];
angles = linspace(-3*pi/4,3*pi/4,1081);
for k1=1:100
    range1=range_pairs(1,k1,1,:);
    range2=range_pairs(1,k1,2,:);
    scan1 = lidarScan(range1(:),angles);
    scan2 = lidarScan(range2(:),angles);
    ranges{k1}={scan1,scan2};
    pose1=pose_rels(1,k1,:);
    poses=[poses;pose1(:)'];
    figure(1)
    plot_scanMatching(ranges,poses,k1)
    pause(0.5)
end

function plot_scanMatching(ranges,poses,idx)
    s1 = ranges{idx}{1,1};
    s2 = ranges{idx}{1,2};
    s2Transformed = transformScan(s2,poses(idx,:));
    plot(s1)
    hold on
    plot(s2)
    hold on
    plot(s2Transformed)
    legend('range1','range2','transform2')
    hold off
end


