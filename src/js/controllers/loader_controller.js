import { Controller } from "stimulus"

export default class extends Controller {

  setData(response) {
    this.element.innerHTML = response
  }

  getData() {
    this.element.innerHTML = this.loader()
    const period = this.data.get("period") ? this.data.get("period") : "7d"
    const goal = this.data.get("goal")
    const site_path = this.data.get("site-path")
    var url = this.data.get("url") + "?period=" + period
    if(goal != null) {
      url = url + "&goal_id=" + goal
    }
    if(site_path != null) {
      url = url + "&site_path=" + site_path
    }
    fetch(url).then(response => {
      return response.text()
    }).then(response => {
      return this.setData(response)
    })
  }

  connect() {
    this.getData();
  }

  loader() {
    return "<div class=\"w-1/6 h-24 mb-2 mx-auto\"><div class=\"lds-ring\"><div></div><div></div><div></div><div></div></div></div>"
  }

}
