## Your very own Media Conversion Tool (lite)

###### Limitations: The *lite* tag indicates the simplicity of the tool. It is a one at a time operation, meant to give the user easy 1,2,3 steps to get their desired outcome. Due to the nature of its simplicity - options are limited to about 20. But the script is well structured, about 200 lines of code, it can be easily forked and modified to fully utilize the power of FFMPEG, without the need for GUI.

## Brief Description

This tool is a simple & light weight Bash script that utilizes the FFMPEG library. It gives the user very easy 1-2-3 steps to convert different media files (gif,mp4,mkv,webm,webp) to different types with different formats and different flavors.

The script can be run in any directory, you can **drag & drop** your media file into the script and it will detect it.

You can review the ffmpeg log, and navigate between the Main Menu to start over again.

## See it in action

https://github.com/soulhotel/yor-mc-lite/assets/155501797/d80cb9cb-5229-472a-aa12-a15b83ffcc56

###### this video was downsized using yor-mc-lite (to meet github filesize standard).

## Usage

- Git clone this repo or download the source above
- Make the script an executable then run it
- Drag a file in, or type the file path
- Make your choices
- Profit

```
git clone https://github.com/soulhotel/yor-mc-lite.git
```
```
cd yor-mc-lite
chmod +x yor-mc-lite.sh
```

To have it show up in your applications list and searches
- place the .desktop file in the appropriate directory, usually `/home/user/.local/share/applications`.
- If you place the script somewhere other than `~/yor-mc-lite/` then open the .desktop file and make sure the Exec path is set accordlingly.

![2024-06-05_02-07](https://github.com/soulhotel/yor-mc-lite/assets/155501797/d94d9249-a6b7-4003-b7ca-e04adf440bd5)
