myhealth-ios
============

Mobile (iOS) client for myhealth, written with RubyMotion.

NOTE - need access to a running instance of the myhealth server to run. This may/or may not still be available on heroku (http://rds-health.herokuapp.com/users/1/mobile_info/). If not, you'll have to get your own instance running from https://github.com/DiUS/myhealth. You should also run this on a real device, or work out how to add images to the iOS simulator.

# What it does?

Allows users to generate wallpapers (using images from their own device) overlayed with emergency medical data from myhealth (server).

![Alt text](/screen1.jpg)

![Alt text](/screen2.jpg)

Wallpapers are meant to be added as 'Lock Screen' backgrounds, so emergency medical data is available at a glance.

![Alt text](/screen3.jpg)

# Implementation

If you're interested in iOS apps written in RubyMotion, this app shows:
* NavigationView and TabView UI containers
* Formotion (gem) to build iOS forms via simple hash syntax
* Access iOS Photo's API
* Rest API calls and JSON parsing
* Use of Dispatch::Queue to create threads then sync back to main thread
* UIActivityIndicatorView spinners
