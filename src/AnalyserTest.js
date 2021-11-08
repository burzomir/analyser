class AnalyserTest extends HTMLElement {
  constructor() {
    super();
    this._shadowRoot = this.attachShadow({ mode: "open" });
    const content = document.createElement("div");
    content.innerText = "AnalyserTest";
    this._shadowRoot.appendChild(content);
    this.start();
  }

  async start() {
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
    const ctx = new AudioContext();
    const source = ctx.createMediaStreamSource(stream);
    const analyser = ctx.createAnalyser();
    analyser.fftSize = 2048;
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
    const event = new CustomEvent("initialised", { bubbles: true, detail });
    this.dispatchEvent(event);
  }
}

function randomInt() {
  return Math.floor(Math.random() * 10000);
}
window.customElements.define("analyser-test", AnalyserTest);
