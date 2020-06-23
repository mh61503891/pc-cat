class Player {

  constructor(id) {
    this.id = id;
  }

  run() {
    this.runSpeech();
  }

  get onplaying() {
    if (this.video.onplaying)
      return true;
    if (speechSynthesis.speaking)
      return true;
    return false;
  }

  playVideo() {
    this.video.currentTime = this.startTime;
    this.video.play();
  }

  runSpeech() {
    if (speechSynthesis.speaking) {
      speechSynthesis.pause();
    } else if (speechSynthesis.paused) {
      speechSynthesis.resume();
    } else {
      this.playSpeech();
    }
  }

  playSpeech() {
    if (speechSynthesis.paused) {
      speechSynthesis.resume();
    } else {
      let synthes = new SpeechSynthesisUtterance(this.text)
      synthes.rate = 0.9;
      synthes.lang = 'ja-JP';
      speechSynthesis.speak(synthes);
    }
    $('#' + this.id + " div p a svg.feather.feather-play-circle").replaceWith(feather.icons['pause-circle'].toSvg());
  }

  pauseSpeech() {
    if (speechSynthesis.speaking)
      speechSynthesis.pause();
    $('#' + this.id + " div p a svg.feather.feather-pause-circle").replaceWith(feather.icons['play-circle'].toSvg());
  }

  get video() {
    if (this._video === undefined) {
      this._video = document.getElementById('video');
    }
    return this._video;
  }

  get entry() {
    if (this._entry === undefined) {
      this._entry = $(`#${this.id}`);
    }
    return this._entry;
  }

  get startTime() {
    return parseFloat(this.entry.data('start-time'));
  }

  get endTime() {
    return parseFloat(this.entry.data('end-time'));
  }

  get text() {
    return `${this.entry.data('title')}について解説します。${this.entry.data('text')}`;
  }

}

let player;

let video;

function videoOnPlay() {
  console.log('videoOnPlay: ', speechSynthesis);
  if (speechSynthesis.paused) {
    speechSynthesis.resume();
  }
}

function videoOnPause() {
  console.log('videoPnPause: ', speechSynthesis);
  // if (speechSynthesis.speaking) {
  //   speechSynthesis.pause();
  // }
}

function videoOnTimeUpdate() {
  let t = player.video.currentTime;
  if (t !== 0) {
    console.log(t);
    console.log([t, player.startTime, player.endTime])
    if (t < player.startTime || player.endTime < t) {
      media.pause();
    }
  }
}

window.onload = function () {
  media = document.getElementById('video');
  video = media;

  video.addEventListener('play', videoOnPlay);
  video.addEventListener('pause', videoOnPause);
  video.addEventListener('timeupdate', videoOnTimeUpdate);

  document.addEventListener("visibilitychange", function () {
    media.pause();
    console.log('aa');
    speechSynthesis.cancel();
  });
};

function test2(id) {
  player = new Player(id);
  player.run();
}
