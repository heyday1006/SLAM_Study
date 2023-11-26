function theta_pointer = cs_pointer(ranges, cs_percent)
    % compression level

    cs_level = floor(numel(ranges) * cs_percent);
    cs_level = cs_level + 1 - rem(cs_level,2); % even number
    % random selection of identity matrix for compression
    %pointer = randperm(numel(ranges)-2,cs_level-2)+1; %m-2 samples from 2 to n-1
    pointer = [];
    ranges_idx = (2:numel(ranges)-1);
    for i = 1:(cs_level-2)/2
        idx = randi(numel(ranges_idx)-1);
        pointer = [pointer ranges_idx(idx:idx+1)];
        ranges_idx = [ranges_idx(1:idx-1) ranges_idx(idx+2:end)];
    end
    theta_pointer = [1 sort(pointer) numel(ranges)];
end