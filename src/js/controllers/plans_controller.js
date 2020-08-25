import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "price", "name" ]

  connect() {
    Paddle.Setup({ vendor: parseInt(this.data.get("paddle")) })
  }

  get plan() {
    return this.data.get("plan")
  }

  set plan(value) {
    this.data.set("plan", value)
  }

  get price() {
    return this.data.get("price")
  }

  set price(value) {
    this.data.set("price", value)
  }

  switch(event) {
    event.preventDefault()
    var button = event.currentTarget
    var plan = button.getAttribute("data-plan")
    var price = button.getAttribute("data-price")
    this.plan = plan
    this.price = price
    this.update_data(price)
    this.goThroughPlans(plan)
  }

  update_data(price) {
    const priceElm = this.priceTarget
    priceElm.innerHTML = "€" + price
  }

  goThroughPlans(id) {
    const targets = this.element.querySelectorAll("[data-plan]")
    for (const target of targets) {
      this._setPlan(target, id)
    }
  }

  _setPlan(target, plan) {
    const temp_plan = target.getAttribute("data-plan")
    if(temp_plan == plan) {
      target.classList.add("plan-current")
    } else {
      target.classList.remove("plan-current")
    }
  }

  checkout(event) {
    event.preventDefault()
    if(this.plan == undefined) {
      return
    }
    Paddle.Checkout.open({
      product: parseInt(this.plan),
      email: this.data.get("email"),
      passthrough: this.data.get("user"),
      disableLogout: true
    })
  }
}
