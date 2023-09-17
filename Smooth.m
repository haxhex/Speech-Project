% This function smooths the data in pitchFreq using a mean filter over a
% rectangle of size (2*rows+1)-by-(2*columns+1).
function outputData = Smooth(pitchFreq,rows,columns)
    frame_length(1) = rows;
    if nargin < 3
        frame_length(2) = frame_length(1);
    else
        frame_length(2) = columns;
    end
    [row,col] = size(pitchFreq);
    % Building matrices that will compute running sums. The left-matrix, RS,
    % smooths along the rows. The right-matrix, CS, smooths along the
    % columns.
    RS = spdiags(ones(row,2*frame_length(1)+1),(-frame_length(1):frame_length(1)),row,row);
    CS = spdiags(ones(col,2*frame_length(2)+1),(-frame_length(2):frame_length(2)),col,col);
    % Setting all 'NaN' elements of 'pitchFreq' to zero so that these will not
    % affect the summation.
    A = isnan(pitchFreq);
    pitchFreq(A) = 0;
    nrmlize = RS*(~A)*CS;
    nrmlize(A) = NaN;
    outputData = RS*pitchFreq*CS;
    outputData = outputData./nrmlize;
end