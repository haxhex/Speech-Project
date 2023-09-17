function pf = amdf(frame)
    frame_length = length(frame);
    amdf_values = zeros(1, frame_length);
    
    for lag = 1:frame_length
        amdf_values(lag) = sum(abs(frame(1:frame_length-lag+1) - frame(lag:frame_length)));
    end
    
    [~, pf] = min(amdf_values);
end