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


Setting ENV variables
----------------
You'll need to set the three following ENV variables:

* `AMAZON_ACCESS_KEY_ID`: AWS access key.
* `AMAZON_SECRET_ACCESS_KEY`: AWS secret access key.
* `AMAZON_S3_DEFAULT_BUCKET`: Name of the bucket where the uploads will be held.

The last variable is visible in the URL returned to the user: `http://s3.amazonaws.com/{AMAZON_S3_DEFAULT_BUCKET}/some_photo.png`, so make sure you choose something pretty. This value is global for all the S3 namespace, meaning you need to find something unique between all the S3 users ("some-user-name_uploads" should do the trick).

You can set these variables in a `~/.amazon_keys` file:

     export AMAZON_ACCESS_KEY_ID='someaccesskey'
     export AMAZON_SECRET_ACCESS_KEY='fortyweirdcharacters'
     export AMAZON_S3_DEFAULT_BUCKET='joesuploads'

And then include it in your `~/.bash_profile`:

     # place at the bottom of your .bash_profile
     if [[ -f "$HOME/.amazon_keys" ]]; then
         source "$HOME/.amazon_keys";
     fi

Usage
------

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
