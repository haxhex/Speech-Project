[waveform,FS] = audioread('myrecording.wav');
waveform = double(waveform);
frame_length=40; %40ms
N = frame_length*FS/1000; %sample per frame = frame length
waveform_size = length(waveform);
frame_overlap = 0.50; % 50% of frame length
M = frame_overlap * N; % frame shift
FramesCount = (length(waveform)-N)/M + 1;
FramesCount = round(FramesCount)-1; %number of frames in audioclip
high_freq = 400;
low_freq = 75;
global candidate_number; %number of candidates in each frame
candidate_number = 6;
pitch_frequency = amdf_pitch(waveform,FramesCount,N,M,frame_length);
%pitch frequencies and smoothing - amdf
% remove frequencies that are more than 400hz or less than 75
pitch_frequency2 = pitch_frequency;
X = NaN(1,FramesCount);
Y = NaN(1,FramesCount);
for i=1:FramesCount
    for j=1:candidate_number
        if pitch_frequency2(i,j) < low_freq || pitch_frequency2(i,j) >high_freq
            pitch_frequency2(i,j) = nan;
        end
    end
end
pitch_frequency2 = Smooth(pitch_frequency2,20,10);
for i=1:FramesCount
    X(i) = i ;
end
for i=1:FramesCount
    for j=1:candidate_number
        if pitch_frequency2(i,j) > low_freq && pitch_frequency2(i,j) <high_freq
            Y(i) = pitch_frequency2(i,j);
            break;
        end
    end
end
%filtering pitch frequencies without smoothing to show pitch candidates - amdf
%(6 candidate for each frame)
candidate_X = NaN(1,candidate_number*length(pitch_frequency));
candidate_Y = NaN(1,candidate_number*length(pitch_frequency));
for i=1:length(pitch_frequency)
    for j=1:candidate_number
        if pitch_frequency(i,j)>low_freq && pitch_frequency(i,j)<high_freq
            candidate_X((i-1)*candidate_number+j) = i;
            candidate_Y((i-1)*candidate_number+j) = pitch_frequency(i,j);
        end
    end
end
%plot pitch frequencies - amdf
subplot(4,1,2)
plot(candidate_X,candidate_Y,'.','MarkerEdgeColor','r')
ylabel({'Pitch Frequency (Hz)'; 'candidates'}, 'FontSize', 8);
xlim([0 FramesCount])
ylim([50 400])
nanmean(Y)
%plot pitch frequencies (smooth) - amdf
subplot(4,1,1)
plot(X,Y,'m','LineWidth',1.5)
ylabel({'Pitch Frequency (Hz)'; 'smooth contour'}, 'FontSize', 8);
xlim([0 FramesCount])
ylim([50 300])
title('AMDF Function');
%pitch frequencies and smoothing - autocorelation
% remove frequencies that are more than 400hz or less than 75
pitch_frequency_ac = autocorelation_pitch(waveform,FramesCount,N,M,frame_length);
pitch_frequency_ac2 = pitch_frequency_ac;
X2 = NaN(1,FramesCount);
Y2 = NaN(1,FramesCount);
for i=1:FramesCount
    for j=1:candidate_number
        if pitch_frequency_ac2(i,j) < low_freq || pitch_frequency_ac2(i,j) >high_freq
            pitch_frequency_ac2(i,j) = nan;
        end
    end
end
pitch_frequency_ac2 = Smooth(pitch_frequency_ac2,11,2);
for i=1:FramesCount
    X2(i) = i ;
end
for i=1:FramesCount
    for j=1:candidate_number
        if pitch_frequency_ac2(i,j) > low_freq && pitch_frequency_ac2(i,j) <high_freq
            Y2(i) = pitch_frequency_ac2(i,j);
            break;
        end
    end
end
%filtering pitch frequencies without smoothing to show pitch candidates - autocorelation
%(6 candidate for each frame)
candidate_X2 = NaN(1,candidate_number*length(pitch_frequency_ac));
candidate_Y2 = NaN(1,candidate_number*length(pitch_frequency_ac));
for i=1:length(pitch_frequency_ac)
    for j=1:6
        if pitch_frequency_ac(i,j)>low_freq && pitch_frequency_ac(i,j)<high_freq
            candidate_X2((i-1)*candidate_number+j) = i;
            candidate_Y2((i-1)*candidate_number+j) = pitch_frequency_ac(i,j);
        end
    end
end
%plot pitch frequencies - autocorelation
subplot(4,1,4)
plot(candidate_X2,candidate_Y2,'.','MarkerEdgeColor','b')
ylabel({'Pitch Frequency (Hz)'; 'candidates'}, 'FontSize', 8);
xlim([0 FramesCount])
ylim([50 200])
%plot pitch frequencies (smooth) - autocorelation
subplot(4,1,3)
plot(X2,Y2,'c','LineWidth',1.5)
ylabel({'Pitch Frequency (Hz)', '3level-Center-Clipping', 'smooth contour'}, 'FontSize', 8);
xlim([0 FramesCount])
ylim([50 200])
title('Autocorelation Function');
pitch_frequency_cep = cepstrum_pitch(waveform,N,M,FramesCount);
pitch_frequency_cep2 = pitch_frequency_cep;
X3 = NaN(1,FramesCount);
Y3 = NaN(1,FramesCount);
for i=1:FramesCount
    for j=1:candidate_number
        if pitch_frequency_cep2(i,j) < low_freq || pitch_frequency_cep2(i,j) >high_freq
            pitch_frequency_cep2(i,j) = nan;
        end
    end
end
pitch_frequency_cep2 = Smooth(pitch_frequency_cep2-15,20,20);
for i=1:FramesCount
    X3(i) = i ;
end
for i=1:FramesCount
    for j=1:candidate_number
        if pitch_frequency_cep2(i,j) > low_freq && pitch_frequency_cep2(i,j) <high_freq
            Y3(i) = pitch_frequency_cep2(i,j);
            break;
        end
    end
end
%filtering pitch frequencies without smoothing to show pitch candidates - cepstrum
%(6 candidate for each frame)
candidate_X3 = NaN(1,candidate_number*length(pitch_frequency_cep));
candidate_Y3 = NaN(1,candidate_number*length(pitch_frequency_cep));
for i=1:length(pitch_frequency_cep)
    for j=1:candidate_number
        if pitch_frequency_cep(i,j)>low_freq && pitch_frequency_cep(i,j)<high_freq
            candidate_X3((i-1)*candidate_number+j) = i;
            candidate_Y3((i-1)*candidate_number+j) = pitch_frequency_cep(i,j);
        end
    end
end
%plot pitch frequencies - cepstrum
subplot(4,1,4)
plot(candidate_X3, candidate_Y3, '.', 'MarkerEdgeColor', 'g')
ylabel({'Pitch Frequency','candidates'},'Fontsize',8);
xlim([0 FramesCount])
ylim([50 200])
%plot pitch frequencies (smooth) - cepstrum
subplot(4,1,3)
plot(X3,Y3,'g','LineWidth',1.5)
ylabel({'Pitch Frequency (Hz)','smooth contour'},'Fontsize',8);
xlim([0 FramesCount])
ylim([50 200])
title('Cepstrum Function');