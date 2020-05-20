/* eslint no-console:0 */

// Rails Unobtrusive JavaScript (UJS) is *required* for links in Lucky that use DELETE, POST and PUT.
// Though it says "Rails" it actually works with any framework.
require("@rails/ujs").start();

// Turbolinks is optional. Learn more: https://github.com/turbolinks/turbolinks/
require("turbolinks").start();

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import { Dropdown } from "tailwindcss-stimulus-components"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
application.register('dropdown', Dropdown)

document.addEventListener("turbolinks:load", function() {

})

// If using Turbolinks, you can attach events to page load like this:
//
// document.addEventListener("turbolinks:load", function() {
//   ...
// })
