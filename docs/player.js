class Player {

  run(id) {
    this.runVideo(id);
    this.runSpeech(id);
  }

  runVideo(id) {
    if (this.currentVideoId === undefined) {
      this.playVideo(id);
    } else {
      if (this.currentVideoId === id) {
        if (this.video.paused) {
          this.video.play();
        } else {
          this.video.pause();
        }
      } else {
        this.playVideo(id);
      }
    }
  }

  playVideo(id) {
    this.currentVideoId = id;
    this.video.currentTime = this.getStartTime(id);
    this.video.pause();
    this.video.play();
  }

  runSpeech(id) {
    if (this.currentSpeechId === undefined) {
      this.playSpeech(id);
    } else {
      if (this.currentSpeechId === id) {
        if (speechSynthesis.paused) {
          speechSynthesis.resume();
        } else {
          speechSynthesis.pause();
        }
      } else {
        this.playSpeech(id);
      }
    }
  }

  playSpeech(id) {
    this.currentSpeechId = id;
    let text = `${this.getEntry(id).data('title')}について解説します。${this.getEntry(id).data('text')}`;;
    let synthes = new SpeechSynthesisUtterance(text);
    synthes.rate = 0.9;
    synthes.lang = 'ja-JP';
    synthes.onend = (e) => {
      this.currentSpeechId = undefined;
    };
    speechSynthesis.cancel();
    speechSynthesis.speak(synthes);
  }

  get video() {
    if (this._video === undefined) {
      this._video = document.getElementById('video');
    }
    return this._video;
  }

  getEntry(id) {
    return $(`#${id}`);
  }

  getStartTime(id) {
    return parseFloat(this.getEntry(id).data('start-time'));
  }

  getEndTime(id) {
    return parseFloat(this.getEntry(id).data('end-time'));
  }

  onPlay() {
    $('#' + this.currentVideoId + " div p a svg.feather.feather-play-circle")
      .replaceWith(feather.icons['pause-circle'].toSvg());
  }

  onPause() {
    $("svg.feather.feather-pause-circle")
      .replaceWith(feather.icons['play-circle'].toSvg());
  }

  onTimeupdate() {
    let t = this.video.currentTime;
    if (t === 0) {
      return;
    }
    let startTime = this.getStartTime(this.currentVideoId);
    if (t < startTime) {
      this.video.pause();
      this.currentVideoId = undefined;
      return;
    }
    let endTime = this.getEndTime(this.currentVideoId);
    if (endTime < t) {
      this.video.pause();
      this.currentVideoId = undefined;
      return;
    }
  }

}

let player;

window.onload = function () {
  player = new Player();
  player.video.addEventListener('play', () => { player.onPlay() });
  player.video.addEventListener('pause', () => { player.onPause() });
  player.video.addEventListener('timeupdate', () => { player.onTimeupdate() });
  document.addEventListener('visibilitychange', function () {
    player.video.pause();
    speechSynthesis.cancel();
  });
}

function runPlayer(id) {
  player.run(id);
}
