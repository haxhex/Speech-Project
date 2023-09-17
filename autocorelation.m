%method to calculate autocorelation of a frame
function frame_autocorelation = autocorelation(frame_i)
frame_autocorelation = zeros(1,length(frame_i));
for eta=0:length(frame_i)-1
sum=0;
for n=eta:length(frame_i)-1
sum = sum + frame_i(n+1)*frame_i(n+1-eta);
end
frame_autocorelation(eta+1) = sum;
end
end