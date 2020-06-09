import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.element.innerHTML = this.loader()

    this.load()
    if (this.data.has("refreshInterval")) {
      this.startRefreshing()
    }
  }

  disconnect() {
    this.stopRefreshing()
  }

  loader() {
    return "<div class=\"w-1/6 m-auto\"><div class=\"lds-ring\"><div></div><div></div><div></div><div></div></div></div>"
  }

  load() {
    fetch(this.data.get("url"))
    .then(response => response.json())
    .then(json => {
      if(json.page_views > 0) {
        window.location.reload()
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
