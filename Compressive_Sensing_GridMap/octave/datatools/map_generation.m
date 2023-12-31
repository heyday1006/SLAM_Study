%% Map Generation
function map = map_generation()
    %Consists of (x,y) start and end points that define a line in the space
    map = zeros(4,24);
    %Wall Exterior
    map(:,1) = [80; 20; 210; 20];
    map(:,2) = [210; 20; 210; 230];
    map(:,3) = [210; 230; 80; 230];
    map(:,4) = [80; 230; 80; 170];
    map(:,5) = [80; 170; 20; 170];
    map(:,6) = [20; 170; 20; 80];
    map(:,7) = [20; 80; 80; 80];
    map(:,8) = [80; 80; 80; 20];
    %Wall Interior
    map(:,9) = [110; 50; 180; 50];
    map(:,10) = [180; 50; 180; 200];
    map(:,11) = [180; 200; 110; 200];
    map(:,12) = [110; 200; 110; 170];
    map(:,13) = [110; 170; 170; 170];
    map(:,14) = [170; 170; 170; 80];
    map(:,15) = [170; 80; 110; 80];
    map(:,16) = [110; 80; 110; 50];
    %Wall Interior
    map(:,17) = [50; 110; 140; 110];
    map(:,18) = [140; 110; 140; 140];
    map(:,19) = [140; 140; 50; 140];
    map(:,20) = [50; 140; 50; 110];

%     via = [100,35; 185,35; 185,40; 190,45; 195,50; 195,200; 190,205; 185,210; 180,215; 110,215; 105,195; 100,190; 95,185; ...
%         95,170; 90,165; 85,160; 80, 155; 50,155; 45, 150; 40,145; 35,140; 35,110; 40,105; 45, 100; 50,95; 140,95; 145,100; ...
%         150,105; 155,110; 155,140; 150,145; 145,150; 140,155; 50,155; 45, 150; 30,145; 35,140; 35,110; 40,105; ...
%         45,100; 50,95; 80,95; 85,90; 90,85; 95,80; 95,35];
%     % Plot map
%     figure(1)
%     clf
%     hold on
%     for d = 1:size(map,2)
%         plot([map(1,d) map(3,d)],[map(2,d) map(4,d)],'k')
%     end
%     hold on
%     plot(via(:,1),via(:,2),'rx')
%     hold off