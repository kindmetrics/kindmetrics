import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "title", "content" ]

  connect() {
    this.getData()
  }

  get type() {
    return this.data.get("type")
  }

  set type(value) {
    this.data.set("type", value)
  }

  switch(event) {
    event.preventDefault()
    var button = event.target
    var type = button.getAttribute("data-switcher-type")
    this.type = type
    this.getData()
  }

  getData() {
    const element = this.contentTarget
    const title = this.titleTarget
    title.innerHTML = this.type[0].toUpperCase() + this.type.substring(1)
    element.innerHTML = this.loader()
    const period = this.data.get("period") ? this.data.get("period") : "7d"
    fetch(this.data.get("url") + "/" + this.type + "?period=" + period).then(response => {
      return response.text()
    }).then(response => {
      element.innerHTML = response
    })
  }

  loader() {
    return "<div class=\"w-1/6 m-auto\"><div class=\"lds-ring\"><div></div><div></div><div></div><div></div></div></div>"
  }
}
