# Why Privacy Analytics?

When you visit pages like Facebook, Twitter, Amazon and more they track you and use the data they got to position ads for you or even worse, selling your data.

Nowadays more and more people started to understand what companies are doing with their data and what they could do to take back their ownership.

Privacy Analytics tracks visit on your pages but hide all data that can identify a person. The rest of the normal data will be seen as normal. Like:

* Referrers
* Visited page
* Utm source
* Browser
* Device
* Operative System
* Country

You probably noticed that I didn’t include IP Addresses here? It is because good privacy analytics don’t save it. They usually generate a unique hash instead.

## What about Kindmetrics?
Kindmetrics is a very strict privacy analytics service. We do everything normal privacy analytics but have also spread over to also be sure the hardware is on privacy-friendly countries. We also encrypt things we don’t need to know. Like your name and such, those are only seen on payment solution when an invoice is sent.

Our unique hash for users are very similar to other privacy analytics services, it is based on 3 things:
> (domain + IP address + browser)

It is one-way hashed and also salted for that extra security not making me (or someone else) be able to access the data and scrape it for information.

## But Kindmetrics doesn't stop there!
Above is where most of the other privacy-friendly Analytics stop. They use CDN, third parties, they track your email open rate themselves. A bit contradictory we would say ourselves.

Kindmetrics have turned off email tracking, we only use the email for user stuff (confirm and password reset) and the onboarding journey, therefore we don't need to track you.

We have no CDN. Others use CDN like Cloudflare, Netlify, amazon's Cloudfront and more. If they say they don't track, these services will. And they don't know if they log everything. So to be extra sure and be safe for you guys - We won't even use third party cdns, and if we do in future it will be an EU based one.

The third party we are using will be short and most of it will be inside the EU.
We will use:
* Digitalocean - VPS cloud hosting - Frankfurt
* Mailjet - Email service - France

That's it. We don't need more than that.

## Wanna try Kindmetrics?
Kindmetrics is in closed beta. Feel free to contact us at info@kindmetrics.io for access - for free by giving us feedback!
