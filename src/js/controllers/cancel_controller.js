import { Controller } from "stimulus"

export default class extends Controller {

  connect() {
    Paddle.Setup({ vendor: parseInt(this.data.get("paddle")) })
  }

  cancel(event) {
    event.preventDefault()
    Paddle.Checkout.open({
      override: this.data.get("url"),
      success: this.data.get("success")
    })
  }

}
