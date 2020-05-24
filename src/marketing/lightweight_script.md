# Lightweight code that won't slow down your site

Kindmetrics is built to be fast but also to have so small footprint in your website that you won't even notice it. Page speed is important, also on those files you don't see on  the page. All files that load when you visit a page will slow down the page somehow.

## Why should I care about page speed and lightweight code?

Fast and good experience browsing internet is important for everyone right now. Other services is counting in page speed and loading time for metrics and ranking and more. As example:

* Google use pagespeed as one of many metrics to calculate ranking on. An slower page will most likely result in lower ranks, which will give you fewer visitors from the search engines.
* People are impatient and want fast browsing. In average the bounce rate will increase after 2 seconds of page load.
* For some people who are for environment will like that smaller site (file size) will use less electricity and therefore less carbon for every visitor.

## How is analytics script handling this?

Most analytics don't care that much about the sizes of the tracking. It continues a lot of code to track your mouse to saving cookies. Things you might not need if you also want to focus on privacy.

We worked hard to push down the file to as small as 2.3 KB. Compare that to Google Analytics Tag Manager 28 KB,  that means kindmetrics filesize is 7% of Google Analytics. That's pretty good.

So in summary, different analytics file sizes for others are:
* Motomo/Piwik - https://demo-web.matomo.org/piwik.js - 199 KB
* Google Tag Manager - https://www.googletagmanager.com/gtag/js  - 28 KB
* Google analytics - https://www.google-analytics.com/analytics.js - 17.7 KB
* Simpleanalytics - https://scripts.simpleanalyticscdn.com/latest.js - 4.1 KB
* kindmetrics - https://kindmetrics.io/js/track.js - 2.3 KB
