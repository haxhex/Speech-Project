%method to calculate cepstrum of a waveform
%6 pitch candidate for each frame
function pitchFreq_cep = cepstrum_pitch(waveform,N,M,FramesCount)
    global candidate_number;
    pitchFreq_cep = zeros(FramesCount,candidate_number);
    threshold_for_voiced = 2000;
    threshold_for_silence = 0.001;
    window = hamming(N);
    for i=1:FramesCount
        frame_i = waveform((i-1)*M+1:(i-1)*M + N);
        frame_i = frame_i .* window; %windowing
        e = energy(frame_i);
        zcr=ZCR(frame_i);
        if e < threshold_for_silence || zcr > threshold_for_voiced
            continue
        else
            frame=cepstrum(frame_i);
            ceps = highTimeLifter(frame);
            n_ceps=length(ceps);
            ceps=ceps(1:n_ceps/2);%because of symmetry in cepstrum
            [ peaks , Ipos ] = findpeaks(ceps);
            for j=1:candidate_number
                [ maximum , peak ] = max(peaks);
                peaks = peaks(peaks~=maximum);
                if length(peak)>1
                    pitchFreq_cep(i,j) = Ipos(peak(1));
                    pitchFreq_cep(i,j+1) = Ipos(peak(2));
                    Ipos = Ipos(Ipos~=Ipos(peak(1)));
                    Ipos = Ipos(Ipos~=Ipos(peak(1)));
                    j = j+1;
                elseif length(peak)==1
                    pitchFreq_cep(i,j) = Ipos(peak);
                    Ipos = Ipos(Ipos~=Ipos(peak));
                end
            end
        end
    end
end