var Kindmetrics = function () {
  "use strict";

  function Kindmetrics(url, send_pageview) {
    if (send_pageview === void 0) {
      send_pageview = true;
    }

    this.kindmetricsURL = url;
    this.dnt = window.doNotTrack || navigator.doNotTrack || navigator.msDoNotTrack;
    this.trackDocument = window.document;
    this.trackLocation = window.location;

    if (send_pageview) {
      this.start();
    }
  }

  var _proto = Kindmetrics.prototype;

  _proto.do_track = function do_track() {
    if (this.dnt && (this.dnt == "1" || this.dnt == "yes")) {
      return false;
    }

    return true;
  };

  _proto.getUrl = function getUrl() {
    return this.trackLocation.protocol + '//' + this.trackLocation.hostname + this.trackLocation.pathname + this.trackLocation.search;
  };

  _proto.getSource = function getSource() {
    var result = this.trackLocation.search.match(/[?&](ref|source|utm_source)=([^?&]+)/);
    return result ? result[2] : null;
  };

  _proto.getMedium = function getMedium() {
    var result = this.trackLocation.search.match(/[?&](utm_medium)=([^?&]+)/);
    return result ? result[2] : null;
  };

  _proto.ignore = function ignore(reason) {
    console.warn('[Kindmetrics] Ignoring event because ' + reason);
  };

  _proto.track = function track(eventName, options) {
    var _this = this;

    if (!this.do_track()) {
      return ignore("Do not track is enabled");
    }

    if (document.visibilityState === 'prerender') {
      return ignore("prerendering");
    }

    var parentNode = window.document.querySelector('[src*="' + this.kindmetricsURL + '"]');
    var domain = parentNode && parentNode.getAttribute('data-domain');
    var data = {
      name: eventName,
      url: this.getUrl(),
      domain: domain || this.trackLocation.hostname,
      referrer: this.trackDocument.referrer || null,
      screen_width: window.innerWidth,
      source: this.getSource(),
      medium: this.getMedium(),
      user_agent: window.navigator.userAgent
    };
    var url = this.kindmetricsURL + '/api/track';
    var response = fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json;charset=utf-8'
      },
      body: JSON.stringify(data)
    }).then(function (response) {
      if (!response.ok) {
        _this.ignore(payload.name);
      }
    });
  };

  _proto.page = function page() {
    this.track('pageview');
  };

  _proto.setPushState = function setPushState() {
    var his = window.history;

    if (his.pushState) {
      var originalPushState = his['pushState'];

      his.pushState = function () {
        originalPushState.apply(this, arguments);
        window.kindmetrics.page();
      };

      window.addEventListener('popstate', this.page);
    }

    var queue = window.kindmetricsq || [];
    window.kindmetricsq = event;

    for (var i = 0; i < queue.length; i++) {
      event.apply(this, queue[i]);
    }
  };

  _proto.start = function start() {
    try {
      this.setPushState();
      this.page();
    } catch (e) {
      new Image().src = this.kindmetricsURL + '/api/error?message=' + encodeURIComponent(e.message);
    }
  };

  return Kindmetrics;
}();

window.kindmetrics = new Kindmetrics(KINDURL);
