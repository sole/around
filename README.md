around
======

HTML5 foursquare client.

## Installation ##

You need Node.js first (for accessing `npm`)

Also, stylus:

````bash
npm install -g stylus
````

Then

````
npm install
````

To compile the CSS files:

````
stylus --watch --include-css --compress --include www/scss < www/scss/app.styl > www/css/app.css
````

To start the server:

````
cd www
python -m SimpleHTTPServer 8008
````

(or any other web server, really!)

We should automate this with Grunt or something easy.

## "old" installation ##

You need `gem` and `npm` (and thus Ruby and Node.js).

    gem install sass
    gem install --version '~> 0.9' rb-fsevent
    npm install
    ./serve

Then head to [localhost:8008](http://localhost:8008/).

## TODO ##

 * How to add foursquare API key.

# License #

This program is free software; it is distributed under an
[Apache 2.0 License](http://github.com/tofumatt/around/blob/master/LICENSE).

---

Copyright (c) 2013 [Matthew Riley MacPherson](http://lonelyvegan.com).
