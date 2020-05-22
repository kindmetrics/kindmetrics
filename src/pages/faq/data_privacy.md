# Data Privacy

Kindmetrics is made to collect analysis but Kindmetrics can do this without collecting personal data or personally identifiable information (PII)

## Data we collect
Even if we try to collect as little as possible we have to collect some to give you guys a good service. I split it up in 2 different chapters to make it extra clear.

### Log data
We don't log any personal data at all in our own logs. The logs only look like this:
> {"severity":"Info","source":"lucky","timestamp":"2020-05-21T03:33:34Z","status":404,"duration":"5.73ms"}
{"severity":"Info","source":"lucky","timestamp":"2020-05-21T03:33:34Z","method":"GET","path":"/news/wp-login.php"}

We use managed load balancer from Digitalocean in frankfurt which might log the traffic.

### Analytics data
We collect some to be able to present you some analytics of your visitors.

We collect page views, referrer, paths, user agent (browser, OS, device) and ip address.

#### Referrer
> We **collect and save** referrer

Referrer is the url where the user came from to your site. We use it so you can see from which website linked to your website. Example website here could be blogs, news. You can also see the user that came directly to you by your own domain. Later this will be changed to `(direct)`

#### Page url
> We **receive and save** Page url

We sent the path the visitor visited on your website. This is usually the page the javascript was triggered from, or if using SPA (single page application) on every `pushstate`

#### Browser
> We **receive and save** browser

We use the `user-agent` string from the browser to determine which browser every visitor uses.

#### Device type
> We **receive and save** device

This is being parsed from the `user-agent` string, which the web browser sent in every request.

#### Operative system
> We **receive and save** operative system

This is being parsed from the `user-agent` string as well, which the web browser sent in every request.

#### Country
> We **receive and save** country

We use public files with list of countries for each ip-address to map which country an ip-address is from. We can **NOT** see cities, states or something else.

#### IP-address
> We **receive** but **NOT saving** IP-addresses

We get the ip address when tracking the user, we then use it for unique one-way hashing to be able to find unique visitors and for getting an country.

After this are done we throw the ip-address away and don't save it at all.

## Web analytics and GDPR, CCPA and other privacy regulations

We don't save the ip-address in clear format. We use the ip address for:
* Get country
* Create a unique one way hash

After that we throw the ip address away. We can't get the ip. Our unique hash for users are very similar to other privacy analytics services, it is based on 3 things
```
(domain + IP address + browser)
```

## Data processors

We have minimal amount of third parties processors:

* Digitalocean - VPS cloud hosting - office in USA (servers are in Germany)
* Mailjet - Email service - Office in France

We use no cdn, no server-side API calls with private info.

## Operator
All data operator responsibility and questions are to:

Håkan Nylén
hakan@kindmetrics.io
