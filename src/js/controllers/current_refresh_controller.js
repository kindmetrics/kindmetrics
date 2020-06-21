import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["counter"]
  connect() {
    this.load()
    if (this.data.has("refreshInterval")) {
      this.startRefreshing()
    }
  }

  disconnect() {
    this.stopRefreshing()
  }

  load() {
    fetch(this.data.get("url"))
      .then(response => response.json())
      .then(json => {
        if(this.counterTarget.innerHTML != json.current) {
          this.counterTarget.innerHTML = json.current
        }
      })
  }

  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.load()
    }, this.data.get("refreshInterval"))
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }

}
