import { Controller } from "stimulus"

export default class extends Controller {

  setData(response) {
    this.element.innerHTML = response
  }

  getData() {
    const from = this.data.get("from")
    const to = this.data.get("to")
    const goal = this.data.get("goal")
    const site_path = this.data.get("site-path")
    const source = this.data.get("source")
    const medium = this.data.get("medium")
    const country = this.data.get("country")
    const browser = this.data.get("browser")
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
    if(country != null) {
      url = url + "&country=" + country
    }
    if(browser != null) {
      url = url + "&browser=" + browser
    }
    fetch(url).then(response => {
      return response.text()
    }).then(response => {
      this.element.hidden = true
      this.setData(response)
      return this._doInitTransition(this.element)
    })
  }

  connect() {
    this.getData();
  }


  /**
   * @private
   * @param {DOMElement} target
   * @param {boolean} openState
   */
  _doInitTransition (target) {
    const eventName = 'show'

    target.dispatchEvent(
      new Event(`reveal:${eventName}`, { bubbles: true, cancelable: false })
    )

    this.transitionEndHandler = () => {
      this._didEndTransition(target)
    }

    requestAnimationFrame(() => {
      this._transitionSetup(target)

      target.addEventListener('transitionend', this.transitionEndHandler)

      requestAnimationFrame(() => {
        this._doStartTransition(target)
      })
    })
  }

  /**
   * @private
   * @param {DOMElement} target
   */
  _doStartTransition (target) {

    this.data.set('transitioning', 'true')
    if (this.useTransitionClasses) {
      target.classList.add(...this.transitionClasses.end.split(' '))
      target.classList.remove(...this.transitionClasses.start.split(' '))
    } else {
      target.style.transformOrigin = this.transitions.origin
      target.style.transitionProperty = 'opacity transform'
      target.style.transitionDuration = `${this.transitions.duration / 1000}s`
      target.style.transitionTimingFunction = 'cubic-bezier(0.4, 0.0, 0.2, 1)'

      target.style.opacity = this.transitions.to.opacity
      target.style.transform = `scale(${this.transitions.to.scale / 100})`
    }
  }

  /**
   * @private
   * @param {DOMElement} target
   * @param {boolean} openState
   */
  _didEndTransition (target) {
    target.removeEventListener('transitionend', this.transitionEndHandler)
    if (this.useTransitionClasses) {
      target.classList.remove(...this.transitionClasses.before.split(' '))
    } else {
      target.style.opacity = target.dataset.opacityCache
      target.style.transform = target.dataset.transformCache
      target.style.transformOrigin = target.dataset.transformOriginCache
    }
    this._doCompleteTransition(target)
  }

  /**
   * @private
   * @param {DOMElement} target
   * @param {boolean} openState
   */
  _doCompleteTransition (target) {
    this.data.set('transitioning', 'false')
    const eventName = 'shown'

    target.hidden = false

    target.dispatchEvent(
      new Event(`reveal:${eventName}`, { bubbles: true, cancelable: false })
    )

    target.dispatchEvent(
      new Event('reveal:complete', { bubbles: true, cancelable: false })
    )
  }

  /**
   * @private
   * @param {DOMElement} target
   * @param {boolean} openState
   */
  _transitionSetup (target) {
    this.transitionType = 'transitionEnter'

    if (this.transitionType in target.dataset) {
      this.useTransitionClasses = true
      this.transitionClasses = this._transitionClasses(
        target,
        this.transitionType
      )
      target.classList.add(...this.transitionClasses.before.split(' '))
      target.classList.add(...this.transitionClasses.start.split(' '))
    } else {
      this.useTransitionClasses = false
      this.transitions = this._transitionDefaults()
      target.dataset.opacityCache = target.style.opacity
      target.dataset.transformCache = target.style.transform
      target.dataset.transformOriginCache = target.style.transformOrigin

      target.style.opacity = this.transitions.from.opacity
      target.style.transform = `scale(${this.transitions.from.scale / 100})`
    }

    target.hidden = false
  }

  /**
   * @private
   * @param {boolean} openState
   */
  _transitionDefaults () {
    return {
      duration: 200,
      origin: 'center',
      from: {
        opacity: 0
      },
      to: {
        opacity: 1
      }
    }
  }

  /**
   * @private
   * @param {DOMElement} target
   * @param {string} transitionType
   */
  _transitionClasses (target, transitionType) {
    return {
      before: target.dataset[transitionType],
      start: target.dataset[`${transitionType}Start`],
      end: target.dataset[`${transitionType}End`]
    }
  }
}
