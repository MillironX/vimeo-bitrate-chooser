
function H264CodecDisplay(frameHeight, frameWidth, frameRate, bitrate)
clc

% Display the results to the user
    disp('Render your video with the following settings:')
    disp('Codec:     H.264')
    disp(['Frame Height: ' num2str(round(frameHeight)) ' px'])
    disp(['Frame Width:  ' num2str(round(frameWidth)) ' px'])
    disp(['Framerate:    ' num2str(round(frameRate)) ' fps'])
    disp(['Bitrate:      ' num2str(bitrate/1000000) ' Mbps'])
end