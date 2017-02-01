% BitrateChooser v. 0.0.0.1
% Copyright (c) 2016, Thomas A. Christensen II
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in the 
% documentation and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
% This script accepts inputs and chooses the appropriate bitrate and codec
% for a video matching those specifications to be uploaded to Vimeo

% Prepare the workspace for computation
clear
clc
close all

% Ask the user for input
userFrameHeight = input('Please input frame height (px): ');
userFrameWidth = input('Please input frame width (px): ');
userFrameRate = input('Please input the framerate (fps): ');
userMotionRank = input('Please input the Kush motion rank (1, 2, or 4): ');
userVideoLength = input('Please input video length (s): ');

% Determine if ProRes is an available option for the user
userMac = input('Do you own an Apple Macintosh computer? (0/1) ');
if userMac == 1
    % The documented bitrate of ProRes Proxy is 45 Mbps for a
    % 1920x1080p29.87 video.
    % Set the DI codec rate to this number coverted to bits/pixel
    diDataRate = 45*1000000/(1920*1080*29.97);
else
    % The documented bitrate of Cineform Low-Quality is 10 MBps for a
    % 1920x1080p23.976 video.
    % Set the DI codec rate to this number converted to bits/pixel
    diDataRate = 10*8*1000000/(1920*1080*24.976);
end

% Define common frame heights of videos to use
%  (Frame heights taken from: https://en.wikipedia.org/wiki/2K_resolution#/
%                             media/File:Vector_Video_Standards8.svg)
frameHeights = [4096 3840 3440 2560 2048 1920 1680 1440 1366 1280 1152 1080 ...
    1024 960 854 800 768 720 640 540 480 384 352 320];

% Determine where the video fits within these preset frame heights and
% delete any sizes larger that that
smallFrameHeightI = find(frameHeights<=userFrameHeight);
frameHeights = frameHeights(smallFrameHeightI); %#ok<FNDSB>
clear smallFrameHeightI

% Calculate the aspect ratio (width/height)
aspectRatio = userFrameWidth / userFrameHeight;

% Calculate the correct framerate
reFrameRate = userFrameRate;
while reFrameRate > 30
    reFrameRate = reFrameRate / 2;
end

% Calculate the size of a Vimeo Basic weekly quota in bits
vimeoBasicQuota = 500*1000000*8;

% Determine the settings for each codec and frame size
for n = 1:length(frameHeights)
    % Calculate the new frame information for this size
    reFrameHeight = frameHeights(n);
    reFrameWidth = frameHeights(n)*aspectRatio;
    
    % Calculate the amount of data used by this video in DI codec
    diVideoLength = diDataRate*reFrameHeight*reFrameWidth*reFrameRate*...
        userVideoLength;
    
    % Determine if this amount of data is allowed in the Vimeo quota
    if diVideoLength <= vimeoBasicQuota
        DiCodecDisplay(reFrameHeight, reFrameWidth, reFrameRate, userMac);
        return
    end
    
    % Calculate the amount of data this video will require according to the
    % Kush guage
    kushVideoLength = 0.07*reFrameHeight*reFrameWidth*reFrameRate*...
        userVideoLength*userMotionRank;
    
    % Determine if this amount of data is allowed in the Vimeo quota
    if kushVideoLength <= vimeoBasicQuota
        % Calculate the bitrate that maximizes the Vimeo quota
        maxBitrate = vimeoBasicQuota / userVideoLength;
        
        % Display results to the user
        H264CodecDisplay(reFrameHeight, reFrameWidth, reFrameRate, maxBitrate);
        return
    end
end