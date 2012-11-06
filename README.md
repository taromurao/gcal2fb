gcal2fb
=======

Google Calendar easier to organize events than Facebook's Events, but it is a bit cumbersome to integrate with Facebook Page.

This rogram fetches events from a public Google Calendar and posts reminder on a Facebook Page you own.

Deploy
------

This code can be deployed on Heroku.

### Prepare a public Google Calendar

Create a calendar to publish. Make it public. Find the calendar's id, which would look like example_calendar@gmail.com.

### Regisger a FB app and obtain the application's client\_id and client\_secret

Login Facebook and go to [Facebook's Developer](https://developers.facebook.com/). Create an app. Make it, say, 'Website with Facebook Login' and give it Site URL. In the Extended Permission section, add 'manage\_pages' and 'publish\_stream'.

Now go to your web browser and type https://graph.facebook.com/oauth/authorize?client_id=CLIENT_ID&scope=publish_stream,manage_pages&redirect_uri=SITE_URL
Then authorize this app.

### Obtain your never-expiring Facebook Page token

This requires 3 steps

1. Obtain short-lived user token (exiring in 2 hrs)
2. Exchange short-lived user token with long-lived user token (expiring in 60 days)
3. Obtain never-expering page token using long-lived user token (never-expiring)

Go to [Facebook Graph API](https://developers.facebook.com/tools/explorer/). Select your application from 'Application' selection at the right top. You will see your user token for your application.

Install [koala gem](https://github.com/arsduo/koala) in your machine `gem install koala`. Run irb and `require 'koala'`. `oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)` and then `long_user_token = oauth.exchange_access_token(short_user_token)` will give you long-lived user token.

Then use this token to obtain never-expiring page token by `user_graph = Koala::Facebook::API.new(long_user_token)` and `page_token = user_graph.get_page_access_token('page_id')`.

### Push code on Heroku

Clone Gcal2Fb: `clone git://github.com/solacreative/gcal2fb.git`.

Create your heroku app and push Gcal2Fb to your Heroku repo: `git push heroku master`.

### Add Heroku config

In my case, I live in Aisa/Tokyo time zone, so

`heroku config:add DEPLOY=true TZ=Asia/Tokyo CAL_ID=YOUR_GOOGLE_CALENDAR_ID PAGE_TOKEN=YOUR_PAGE_TOKEN`

In case, it might make sense to adjust the LANG setting, too.

### Add scheduler task

First add Heroku's scheduler addon to your app. Go to scheduler setting page and add `bundle exec ruby bin/reminder.rb` and schedule the execution frequencty to 'Daily'.

This should make your event reminder work!


Licence
-------

I keep this code under MIT licence.