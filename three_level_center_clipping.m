%method to apply 3-level-center-clipping on a frame
function frame = three_level_center_clipping(frame_i)
    frame = zeros(1, length(frame_i));
    maximum = max(abs(frame_i));
    c = 0.3;
    for i = 1:length(frame)
        if frame_i(i) >= c * maximum
            frame(i) = 1;
        elseif frame_i(i) > -(c * maximum) && frame_i(i) < c * maximum
            frame(i) = 0;
        elseif frame_i(i) <= -(c * maximum)
            frame(i) = -1;
        end
    end
end