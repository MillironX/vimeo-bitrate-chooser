# Vimeo Bitrate Chooser
Calculates the appropriate bitrate and codec for exporting a video to be uploaded to a Vimeo basic account.

# How to Use
This program requires MATLAB in order to run. Copy all three M-files to the same directory, then set that directory as the working directory (`cd 'C:\Users\Downloads\vimeo-bitrate-chooser'`). Then type `main`, and the program will start. Answer the prompts with your video's information, and press enter. Some clarification:
- When it asks "Do you own a Macintosh?" 0 means false, and 1 means true. Any other input will throw errors.
- The Kush motion rank is based upon "The Kush Gauge" by Kush Amerasinghe of Adobe Systems (https://www.adobe.com/content/dam/Adobe/en/devnet/video/articles/h264_primer/h264_primer.pdf). It boils down to:
  - 1: Low motion. A video that has minimal movement. For example, a person talking in front of a camera without moving much while the camera itself and the background is not moving at all.
  - 2: Medium motion. Some degree of movement, but in a more predictable and orderly manner, which means some relatively slow camera and subject movements, but not many scene changes or cuts or sudden snap camera movements or zooms where the entire picture changes into something completely different instantaneously.
  - 4: High motion. Something like the most challenging action movie trailer, where not only the movements are fast and unpredictable but the scenes also change very rapidly.
