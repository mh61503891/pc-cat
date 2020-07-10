# PC-CAT

## Develoment

## 1. Screen Recording

1. QuickTime Player -> File -> New Screen Recording -> Record Entire Screen
2. Stop Screen Recording
3. QuickTime Player -> Edit -> Remove Audio
4. QuickTime Player -> Edit -> Trim
5. QuickTime Player -> File -> Save...

## 2. Convert videos to MP4

* [HandBrakeCLI: Downloads](https://handbrake.fr/downloads2.php)

For single file:

```sh
$ HandBrakeCLI --input $video.mov --output $video.mp4 --format av_mp4 --optimize --align-av --encoder x264 --quality 22.0 --rate 30 --width 1920 --height 1080 --auto-anamorphic --keep-display-aspect --modulus 2
```

For multiple files:

```sh
$ ls *.mov | xargs -I {} basename {} .mov | xargs -I {} HandBrakeCLI --input {}.mov --output {}.mp4 --format av_mp4 --optimize --align-av --encoder x264 --quality 22.0 --rate 30 --width 1920 --height 1080 --auto-anamorphic --keep-display-aspect --modulus 2
```

## 3. Create thumbnails

```sh
$ ls *.mp4 | xargs -I {} basename {} .mp4 | xargs -I {} ffmpeg -i {}.mp4 -vf "thumbnail,scale=1024:640" -frames:v 1 {}.png
```

```sh
$ bundle exec nanoc live
```
