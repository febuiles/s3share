S3Share
=======

S3Share is a simple script to upload your files to S3 and share them with your friends.

Requirements
------------
* Ruby
* aws-s3 gem

Installation
------------

You can install from Rubygems

    $ gem install s3share

Or you can download the source and build it manually:

    $ git clone https://febuiles@github.com/febuiles/s3share.git
    $ rake install

You'll need to set...

Usage
-----

    $ s3.rb [file]

An example:

    $ s3.rb kezia.png

      kezia.png uploaded to: http://s3.amazonaws.com/heroin-uploads/kezia.png

By default all the uploaded files will be publicly readable. Once the upload is complete the URL will be copied to your clipboard for easy access.

Bugs/Contact
------------

Got a problem? Create an issue in the [Github Tracker](https://github.com/febuiles/s3share/issues).

Author
------

Federico Builes - federico@mheroin.com - @febuiles