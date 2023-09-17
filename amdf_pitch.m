function pitchFreq = amdf_pitch(waveform,FramesCount,N,M,frame_length)
    global candidate_number;
    threshold_for_silence = 0.001;
    threshold_for_voiced = 2000;
    window = hamming(N);
    amdfs = [];
    
    for i = 1:FramesCount
        frame_i = waveform((i-1)*M+1:(i-1)*M + N); %splitting ith frame
        frame_i = frame_i .* window; %windowing
        dc = DC(frame_i);
        frame_i = frame_i - dc; %removing DC from each frame
        e = energy(frame_i);
        z = ZCR(frame_i);
        pf = amdf(frame_i); %check if frame is not noise or unvoiced
        
        if e > threshold_for_silence || z < threshold_for_voiced
            amdfs = [amdfs; pf];
        else
            amdfs = [amdfs; zeros(1, N)];
        end
    end
    
    for i = 1:FramesCount
        p = smooth(smooth(smooth(amdfs(i,:), 10), 10), 50);
        p = -p;
        
        if numel(p) >= 3 % Check if p has at least three samples
            [peaks, Ipos] = findpeaks(p);
        else
            peaks = [];
            Ipos = [];
        end
        
        Ipos_new = [];
        minimum = min(candidate_number, length(Ipos));
        
        for j = 1:minimum
            max_val = min(peaks);
            z = find(peaks == max_val);
            
            if numel(z) == 1
                Ipos_new = [Ipos_new, Ipos(z)];
                peaks = peaks(peaks ~= max_val);
                Ipos = Ipos(Ipos ~= Ipos(z));
            elseif numel(z) == 2
                n = Ipos(z);
                Ipos_new = [Ipos_new, n(1), n(2)];
                peaks = peaks(peaks ~= max_val);
                Ipos = Ipos(Ipos ~= n(1));
                Ipos = Ipos(Ipos ~= n(2));
            end
        end
        
        Ipos = Ipos_new;
        
        for j = 1:length(Ipos)
            pitchFreq(i, j) = 1 / ((Ipos(j)) * frame_length / (N * 1000));
        end
        
        if length(Ipos) <= 1
            pitchFreq(i, :) = zeros(1, candidate_number);
        end
    end
end
