import { Controller } from "stimulus"
import Datamap from 'datamaps'
import { useResize } from 'stimulus-use'
export default class extends Controller {

  createChart(ctx, response) {
    const { data } = response

    var dataset = {}

    var onlyValues = data.map(function(obj){ return obj.count; });
    var minValue = Math.min.apply(null, onlyValues),
            maxValue = Math.max.apply(null, onlyValues);

    var paletteScale = d3.scale.linear()
            .domain([minValue,maxValue])
            .range(["#EFEFFF","#02386F"]);

    data.forEach(function(item){ //
        // item example value ["USA", 70]
        var iso = item.country,
                value = item.count;
        dataset[iso] = { numberOfThings: value, fillColor: paletteScale(value) };
    });
    this.element.innerHTML = ""
    this.map = new Datamap({
        element: this.element,
        scope: 'world',
        responsive: true,
        fills: { defaultFill: '#e2e8f0' },
        data: dataset,
        done: () => {
          this._doInitTransition(this.element)
        },
        geographyConfig: {
          highlightFillColor: function(geo) {
                  return geo['fillColor'] || '#e2e8f0';
              },
            highlightBorderColor: '#B7B7B7',
            popupTemplate: function(geo, data) {
                if (!data) { return ; }
                return ['<div class="hoverinfo">',
                    '<strong>', geo.properties.name, '</strong>',
                    '<br>Visitors: <strong>', data.numberOfThings, '</strong>',
                    '</div>'].join('');
            }
        }
    });
  }

  getData() {
    const from = this.data.get("from")
    const to = this.data.get("to")
    var url = this.data.get("url") + "?from=" + from + "&to=" + to
    fetch(url).then(response => {
      return response.json()
    }).then(response => {
      return this.createChart(this.element, response)
    })
  }

  resize({ height, width }) {
    if(this.map) {
      this.map.resize();
    }
  }

  connect() {
    useResize(this)
    this.element.innerHTML = this.loader()
    this.getData();
  }

  loader() {
    return "<div class=\"w-1/6 mx-auto\"><div class=\"lds-ring\"><div></div><div></div><div></div><div></div></div></div>"
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
