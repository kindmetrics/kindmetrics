(function(window, kindmetricsURL){
  'use strict';

  try {
    const parentNode = window.document.querySelector('[src*="' + kindmetricsURL +'"]')
    const domain = scriptEl && scriptEl.getAttribute('data-domain')

    const CONFIG = {
      domain: domain || window.location.hostname,
    }

    function getUrl() {
      return window.location.protocol + '//' + window.location.hostname + window.location.pathname + window.location.search;
    }

    function getUtmSource() {
      const result = window.location.search.match(/[?&](ref|source|utm_source)=([^?&]+)/);
      return result ? result[2] : null
    }

    function ignore(reason) {
      console.warn('[Kindmetrics] Ignoring event because ' + reason);
    }

    function done(reason) {
      console.info('[Kindmetrics] Sent event to server with ' + reason);
    }

    function trigger(eventName, options) {
      var payload = {}
      payload.name = eventName
      payload.url = getUrl()
      payload.domain = CONFIG['domain']
      payload.referrer = window.document.referrer || null
      payload.source = getUtmSource()
      payload.user_agent = window.navigator.userAgent
      payload.screen_width = window.innerWidth

      url = kindmetricsURL + '/api/track'

      let response = fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify(payload)
      }).then(response => {
        if(response.ok) {
          done(payload.name)
        } else {
          ignore(payload.name)
        }
      })
    }

    function page() {
      trigger('pageview')
    }

    var his = window.history
    if (his.pushState) {
      var originalPushState = his['pushState']
      his.pushState = function() {
        originalPushState.apply(this, arguments)
        page();
      }
      window.addEventListener('popstate', page)
    }

    const queue = (window.kindmetrics && window.kindmetrics.q) || []
    window.kindmetrics = trigger
    for (var i = 0; i < queue.length; i++) {
      trigger.apply(this, queue[i])
    }

    page()
  } catch(e) {
    new Image().src = kindmetricsURL + '/api/error?message=' + encodeURIComponent(e.message)
  }
})(window, 'http://localhost:5000')
