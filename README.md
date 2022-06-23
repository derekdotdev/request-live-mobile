# Request Live Music

This is a mobile application designed to streamline the song requesting process in noisy live music venue environments. Request Live allows free users (Requesters) to locate nearby premium users (Entertainers) to make song requests. Entertainers are able to go 'live on stage' (which requires venue name and address or geolocation gathered with native device Location Services) or 'live on air' (which only requires a link to their radio station or podcast). (Location is not collected for 'on air' for obvious privacy purposes). This way, Requesters can discover new venues and artists when they're out on the town as well as make requests to their favorite radio jocks or streamers. 

The application has come a long way since this recording, but here is a basic demonstration of its functionality. 

[Request Live video demo](https://vimeo.com/708658225)


## Request Live TDL
- Implement subscription model (via in-app purchase or similar) to differentiate between Requesters and Entertainers
- Implement OAuth2 login methods (Google, FB, etc.) to simplify/speed up the registration process
- Implement GetX for state management
- Implement GetX for URL route management (web app)
- Add requests played counters to user profile pages
- Allow Entertainers to:
  - Mark requests as played
  - Toggle Request list to show all, played, not played yet requests
  - Add a tip jar to profile via CashApp, PayPal or similar (will appear to Requester after each request)
  - Add social media links to profile
  - Reply to Requesters via messenger?

- Allow Requesters to:
  - Follow Entertainers
  - Tip Entertainers

- Finally, publish to Web, AppStore, and Google Play Store!!
