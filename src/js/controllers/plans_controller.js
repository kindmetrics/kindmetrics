import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "price", "name", "event" ]

  connect() {
    Paddle.Setup({ vendor: parseInt(this.data.get("paddle")) })
    this.default()
    this.current()
  }

  get plan() {
    return this.data.get("plan")
  }

  set plan(value) {
    this.data.set("plan", value)
  }

  default() {
    var defaultPlan = this.data.get("default")
    if(defaultPlan != undefined) {
      this.goThroughPlans(defaultPlan)
    }
  }

  current() {
    var currentPlan = this.data.get("current-plan")
    if(currentPlan != "") {
      this.goThroughDisablePlans(currentPlan)
    }
  }

  switch(event) {
    event.preventDefault()
    var button = event.currentTarget
    var plan = button.getAttribute("data-plan")
    if(plan == this.data.get("current-plan")) {
      return
    }
    this._setData(button)
    this.goThroughPlans(plan)
  }

  update_data(price, events) {
    const priceElm = this.priceTarget
    const eventElm = this.eventTarget
    priceElm.innerHTML = price + "€"
    eventElm.innerHTML = events
  }

  goThroughPlans(planId) {
    const targets = this.element.querySelectorAll("[data-plan]")
    for (const target of targets) {
      this._setPlan(target, planId)
    }
  }

  goThroughDisablePlans(planId) {
    const targets = this.element.querySelectorAll("[data-plan]")
    for (const target of targets) {
      const temp_plan = target.getAttribute("data-plan")
      if(temp_plan == planId) {
        console.log("found it")
        target.classList.add("plan-disable")
        return
      }
    }
  }

  _setData(button) {
    var price = button.getAttribute("data-price")
    var events = button.getAttribute("data-events")
    var plan = button.getAttribute("data-plan")
    this.plan = plan
    this.update_data(price, events)
  }

  _setPlan(target, plan) {
    const temp_plan = target.getAttribute("data-plan")
    if(temp_plan == plan) {
      target.classList.add("plan-current")
      this._setData(target)
    } else {
      target.classList.remove("plan-current")
    }
  }

  checkout(event) {
    if(this.data.get("upgrade") == "true") {
      return window.location = "http://localhost:5000/me/plans/update?plan_id=" + this.plan
    }

    event.preventDefault()
    if(this.plan == undefined) {
      return
    }
    Paddle.Checkout.open({
      product: parseInt(this.plan),
      email: this.data.get("email"),
      passthrough: this.data.get("user"),
      disableLogout: true,
      success: this.data.get("success")
    })
  }
}
