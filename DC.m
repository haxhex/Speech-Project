function dc = DC(frame_i)
    dc = sum(frame_i)/length(frame_i);
end
function zcr = ZCR(frame_i)
    FrameZCR = 0;
    for n=2:length(frame_i) %claculate ZCR
        FrameZCR=FrameZCR + abs(sign(frame_i(n))-sign(frame_i(n-1)));
    end
    zcr = FrameZCR/(2*length(frame_i));
end