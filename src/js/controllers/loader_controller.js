import { Controller } from "stimulus"

export default class extends Controller {

  setData(response) {
    this.element.innerHTML = response
  }

  getData() {
    this.element.innerHTML = this.loader()
    const from = this.data.get("from")
    const to = this.data.get("to")
    const goal = this.data.get("goal")
    const site_path = this.data.get("site-path")
    const source = this.data.get("source")
    const medium = this.data.get("medium")
    var url = this.data.get("url") + "?from=" + from + "&to=" + to
    if(goal != null) {
      url = url + "&goal_id=" + goal
    }
    if(source != null) {
      url = url + "&source_name=" + source
    }
    if(medium != null) {
      url = url + "&medium_name=" + medium
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
