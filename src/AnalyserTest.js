class AnalyserTest extends HTMLElement {
  constructor() {
    super();
    this._shadowRoot = this.attachShadow({ mode: "open" });
    const content = document.createElement("div");
    content.innerText = "AnalyserTest";
    this._shadowRoot.appendChild(content);
    setTimeout(() => {
      const event = new CustomEvent("initialised", { bubbles: true });
      this.dispatchEvent(event);
    }, 3000);
  }
}

window.customElements.define("analyser-test", AnalyserTest);
