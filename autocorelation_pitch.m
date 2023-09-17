%method to calculate autocorelation of a waveform
%6 pitch candidate for each frame
function pitchFreq_ac = autocorelation_pitch(waveform,FramesCount,N,M,frame_length)
    global candidate_number;
    window = hamming(N);
    threshold_for_voiced = 2000;
    threshold_for_silence = 0.001;
    autocorelations = [];
    for i=1:FramesCount
        frame_i = waveform((i-1)*M+1:(i-1)*M + N);%splitting ith frame
        frame_i = frame_i .* window; %windowing
        dc = DC(frame_i);
        frame_i = frame_i - dc; %removing DC from each frame
        Energy=energy(frame_i);
        zcr=ZCR(frame_i);
        frame = three_level_center_clipping(frame_i);
        auto = autocorelation(frame);
        if Energy < threshold_for_silence || zcr > threshold_for_voiced
            autocorelations = [autocorelations ; zeros(1,N) ];
        else
            autocorelations = [autocorelations ; auto ];
        end
    end
    for i=1:FramesCount
        p = smooth(smooth(smooth(autocorelations(i,:),10),10)) ;
        [peaks,Ipos] = findpeaks(p);
        Ipos_final = [];
        minimum = min(candidate_number,length(Ipos));
        for j=1:minimum
            m = max(peaks);
            n = find(peaks==m);
            if length(n)==1
                Ipos_final = [ Ipos_final , Ipos(n) ];
                peaks = peaks(peaks~=m);
                Ipos = Ipos(Ipos~=Ipos(n));
            elseif length(n)==2
                et = Ipos(n);
                Ipos_final = [ Ipos_final , et(1) ,et(2) ];
                peaks = peaks(peaks~=m);
                Ipos = Ipos(Ipos~=et(1));
                Ipos = Ipos(Ipos~=et(2));
            end
        end
        Ipos = Ipos_final;
        for j=1:length(Ipos)
            pitchFreq_ac(i,j) = 1/((Ipos(j))*frame_length/(N*1000));
        end
        if length(Ipos)<=1
            for j=1:candidate_number
                pitchFreq_ac(i,j)=0;
            end
        end
    end
end