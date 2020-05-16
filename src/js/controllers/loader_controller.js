import { Controller } from "stimulus"

export default class extends Controller {

  setData(response) {
    this.element.innerHTML = response
  }

  getData() {
    this.element.innerHTML = this.loader()
    fetch(this.data.get("url")).then(response => {
      return response.text()
    }).then(response => {
      return this.setData(response)
    })
  }

  connect() {
    this.getData();
  }

  loader() {
    return "<div class=\"w-1/6 m-auto\"><div class=\"lds-ring\"><div></div><div></div><div></div><div></div></div></div>"
  }

}
