(function(window, kindmetricsURL){
  'use strict';

  const trackDocument = window.document
  const trackLocation = window.location
  const dnt = window.doNotTrack || navigator.doNotTrack || navigator.msDoNotTrack

  try {
    const parentNode = window.document.querySelector('[src*="' + kindmetricsURL +'"]')
    const domain = parentNode && parentNode.getAttribute('data-domain')

    function getUrl() {
      return trackLocation.protocol + '//' + trackLocation.hostname + trackLocation.pathname + trackLocation.search;
    }

    function getSource() {
      const result = trackLocation.search.match(/[?&](ref|source|utm_source)=([^?&]+)/)
      return result ? result[2] : null
    }

    function getMedium() {
      const result = trackLocation.search.match(/[?&](utm_medium)=([^?&]+)/)
      return result ? result[2] : null
    }

    function do_track() {
      if (dnt && (dnt == "1" || dnt == "yes")) {
        return false
      }
      return true
    }

    function ignore(reason) {
      console.warn('[Kindmetrics] Ignoring event because ' + reason);
    }

    function event(eventName, options) {
      if(!do_track()) {
        return ignore("Do not track is enabled")
      }
      if (document.visibilityState === 'prerender') {
        return ignore("prerendering");
      }
      var data = {
        name: eventName,
        url: getUrl(),
        domain: domain || trackLocation.hostname,
        referrer: trackDocument.referrer || null,
        screen_width: window.innerWidth,
        source: getSource(),
        medium: getMedium(),
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
        if(!response.ok) {
          ignore(payload.name)
        }
      })
    }

    function page() {
      event('pageview')
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
    window.kindmetrics = event
    for (var i = 0; i < queue.length; i++) {
      event.apply(this, queue[i])
    }

    page()
  } catch(e) {
    new Image().src = kindmetricsURL + '/api/error?message=' + encodeURIComponent(e.message)
  }
})(window, KINDURL)
