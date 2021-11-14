class AnalyserNode extends HTMLElement {
  fftSize = 2048;

  constructor() {
    super();
    this.start();
  }

  async start() {
    const stream = await navigator.mediaDevices.getDisplayMedia({
      audio: true,
      video: true
    });
    const ctx = new AudioContext();
    const source = ctx.createMediaStreamSource(stream);
    const analyser = ctx.createAnalyser();
    analyser.fftSize = this.fftSize;
    source.connect(analyser);
    this.analyser = analyser;
    this.buffer = new Uint8Array(analyser.frequencyBinCount);
    this.emitEvent = this.emitEvent.bind(this);
    this.emitEvent();
  }

  emitEvent() {
    requestAnimationFrame(this.emitEvent);
    this.analyser.getByteFrequencyData(this.buffer);
    const detail = [...this.buffer];
    const event = new CustomEvent("GotByteFrequencyData", {
      bubbles: true,
      detail,
    });
    this.dispatchEvent(event);
  }
}

function randomInt() {
  return Math.floor(Math.random() * 10000);
}
window.customElements.define("analyser-node", AnalyserNode);
