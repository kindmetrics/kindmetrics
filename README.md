# Kindmetrics

Kindmetrics is an strictly privacy focused web analytics for your website.

Thanks to being built on Crystal, Kindmetrics is very small when compiled (~10MB) and is very fast. Faster than Elixir, Rails or java. It use very little cpu and memory and could be deployed on old machines with linux as distro.

It is built based on following ideas:
* Simplicity
* Privacy for both you and your visitors
* GDPR compliant
* NO COOKIES

And as a service we follow these ideas:
* Only EU-based services used, except for DO but the servers will be on EU soil
  * If we find a better managed kubernetes service in EU than DO, with managed db, we will move.
* No CDN for APIs, If we add cdn for the assets files it will be an EU-based one - but for now we won't.
* We shall always force privacy-features like DNT.

And for the technical stand, we follow these ideas:
* Small footprint (both in size and traffic)
* As less third party dependent as possible
* Focus on one thing only: Analytics
* No SPA here. we focus on backend with some javascript.

## Technical stuff
Kindmetrics is built on:
* Lucky framework, on Crystal language
* Tailwind css
* Stimulus.js
* Chart.js

### Setting up the project

If you want to run this project for dev, like when you want to fix bugs or new features, you have to install Crystal language. You can find more info about crystal at https://www.crystal-lang.org - You can use crenv, asdf or similar. Check the details on https://luckyframework.org/guides/getting-started/installing#1-install-crystal

Kindmetrics use postgresql 

When that is done, you have to setup the lucky project:
1. [Install required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies)
1. Update database settings in `config/database.cr`
1. Run `script/setup`
1. Run `lucky dev` to start the app

### Tests
Kindmetrics have some tests, even if they could be more. But you can run them by:
```
crystal spec
```
And the code should be in `/src` and the tests in `/spec`

### Deployment
You can easily deploy this. Just clone this to your computer and run `docker build .` and deploy that container to your server. Kindmetrics use all lucky framework environment variables which can be seen here: https://luckyframework.org/guides/deploying/ubuntu#creating-a-systemd-unit-file-for-your-app

Kindmetrics is dependent on some SMTP mail server and postgresql. Be sure to have those prepared.

### Contribute
I am all open for any help I can get with this project.

Fork this repo, add push your changes to a new branch and create an pull request. I will review when I can. if they follow the aboves ideas and standpoints and don't go against my plans for future, which can be seen in the issues I will approve. Just add tests. Even if I have been bad on that I am trying to be better.

