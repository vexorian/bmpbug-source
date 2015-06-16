# bmpbug
This is the sourcecode for twitter bot [@bmpbug][https://twitter.com/bmpbug]. A simple idea, you send the bot an @-reply contaning an image and the bot will return a vertical flip of the provided image. It was intended more as a stub project, once we know how to make a bot that processes images doing something this simple, we may in the future do bots that do more complex / interesting processing than just flipping.

With time it became evident that @bmpbug's interactions with other graphic processing bots can allow the other bots to create interesting images by basically processing each previous result into something new. bmpbug can also work as an intermediary between distinct bots, sometimes aiding in the creation of pictures that have been a joint work by 5 or more bots.

## twitter-bot-template

This is based on another project: [The twitter-bot-template](https://github.com/vexorian/twitter-bot-template). Most of the twitter-related work is done by that. In fact, the only difference between this project and the twitter-bot-template is in content.rb, some small tweaks to config.rb and an extra requirement (Image Magick is used to flip images) in Gemfile.

Refer to twitter-bot-template's instructions (which hopefully exist by the time you are reading this) to know how to setup a bot that uses that template. 
