(function(window, kindmetricsURL){
  'use strict';

  try {
    const parentNode = window.document.querySelector('[src*="' + kindmetricsURL +'"]')
    const domain = parentNode && parentNode.getAttribute('data-domain')

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

    function trigger(eventName, options) {
      var data = {
        name: eventName,
        url: getUrl(),
        domain: domain || window.location.hostname,
        referrer: window.document.referrer || null,
        source: getUtmSource(),
        user_agent: window.navigator.userAgent
      }

      const url = kindmetricsURL + '/api/track'

      let response = fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify(data)
      }).then(response => {
        if(response.ok) {
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
        page()
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
})(window, KINDURL)
