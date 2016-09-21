# home_dashbard
Dashboard for home status

This page contains Dashing code, plus numerous plugins for dashing, and my own configuration and changes.

INSTALL
 - install Xcode from app store
 - install dev tools: xcode-select --install
 - run: sudo gem install bundler
 - install dashing following instructions on http://dashing.io
 - install node-mjpeg-proxy, repo: https://github.com/legege/node-mjpeg-proxy
 - cd node-mjpeg-proxy
 - npm install
 - config example/express-app.js to point cam2/image2 to front door camera mjepg url
 - run: node express-app.js
 - clone repo https://github.com/thisisdavidbell/home_dashboard
 - cd home_dashboard
 - compile spotify.applescript to spotify.scpt: osacompile -o spotify.scpt spotify.applescript 
 - run: dashing start
 - dashboard now at: http://<ipaddress>:3030/homedash

NOTES



- see dashing readme for previous contentx
