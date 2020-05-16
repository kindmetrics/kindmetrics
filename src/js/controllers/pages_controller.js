import { Controller } from "stimulus"

export default class extends Controller {

  setData(response) {
    this.element.innerHTML = response
  }

  getData() {
    fetch(this.data.get("url")).then(response => {
      return response.text()
    }).then(response => {
      return this.setData(response)
    })
  }

  connect() {
    this.getData();
  }

}
