class AnalyserTest extends HTMLElement {
  constructor() {
    super();
    this._shadowRoot = this.attachShadow({ mode: "open" });
    const content = document.createElement("div");
    content.innerText = "AnalyserTest";
    this._shadowRoot.appendChild(content);
    this.emitEvent();
  }

  emitEvent() {
    requestAnimationFrame(() => {
      const detail = [...new Uint8Array([randomInt(), randomInt()])];
      const event = new CustomEvent("initialised", { bubbles: true, detail });
      this.dispatchEvent(event);
      this.emitEvent();
    });
  }
}

function randomInt() {
  return Math.floor(Math.random() * 10000);
}
window.customElements.define("analyser-test", AnalyserTest);
