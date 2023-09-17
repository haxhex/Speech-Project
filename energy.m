function en = energy(frame_i)
en = sum(frame_i.*frame_i)/length(frame_i);
end
%method to calculate amdf of a frame
function frame_amdf = amdf(frame_i)
    frame_amdf = zeros(1,length(frame_i));
    for eta=0:length(frame_i)-1
        sum=0;
        for n=eta:length(frame_i)-1
            sum = sum + abs((frame_i(n+1)-frame_i(n+1-eta)));
        end
    frame_amdf(eta+1) = sum;
    end
end