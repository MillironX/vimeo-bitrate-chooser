function DiCodecDisplay(frameHeight, frameWidth, frameRate, blnMac)
clc

% Check if the user has a Mac computer or not
    if blnMac == 1
        strDi = 'ProRes Proxy';
    else
        strDi = 'Cineform, Low-Quality';
    end
    
    % Display the results
    disp('Render your video with the following settings:')
    disp(['Codec:        ' strDi])
    disp(['Frame Height: ' num2str(round(frameHeight)) ' px'])
    disp(['Frame Width:  ' num2str(round(frameWidth)) ' px'])
    disp(['Framerate:    ' num2str(frameRate) 'fps'])
end