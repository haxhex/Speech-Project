function zcr = ZCR(signal)
    % Calculate the Zero Crossing Rate (ZCR) of a signal
    zcr = sum(signal(1:end-1).*signal(2:end) < 0);
end
