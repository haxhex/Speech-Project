%method to apply high time liftering on a frame
function ceps = highTimeLifter(frame)
NN = 20;
ceps = zeros(1, length(frame));
for i=1:length(ceps)
if i >= NN
ceps(i) = frame(i);
else
ceps(i) = 0;
end
end
end