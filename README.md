# PC-CAT

## Develoment

### Run the local server

```sh
$ ruby -run -e httpd docs -p 8080
```

### Build documents

```sh
$ bundle exec exe/generate
```

### Snippets

```sh
$ for VIDEO in $(ls *.mp4 | sed 's/.mp4//'); do; ffmpeg -i $VIDEO.mp4 -vf "thumbnail,scale=1024:640" -frames:v 1 $VIDEO.png; done
```
