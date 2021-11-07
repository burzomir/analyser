class AnalyserTest extends HTMLElement {
  constructor() {
    super();
    this._shadowRoot = this.attachShadow({ mode: "open" });
    const content = document.createElement("div");
    content.innerText = "AnalyserTest";
    this._shadowRoot.appendChild(content);
  }
}

window.customElements.define("analyser-test", AnalyserTest);
