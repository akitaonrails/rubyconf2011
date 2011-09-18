RUBYCONF BRASIL
===============

This is the source code for the RubyConf Brasil Website. It is based on the
excellent [nanoc3](http://nanoc.stoneship.org) static site generator.

INSTALL
-------

You need to have Ruby installed and the [Bundler](http://gembundler.com/) gem.

Then just run `bundler` to install the dependencies and `bundle exec nanoc3 compile`.
This will generate the entire website in the 'output' directory.

You can now run `bundle exec nanoc3 autocompile` to run the Webrick web server and
see the generated website opening a web browser pointing to http://localhost:3000

Now whenever you change a file in the /contents directory, Nanoc3 should recompile
the static output.

SPEAKER
-------

If you're a speaker, fork this project and change your information. You can change
your profile information at lib/speakers folder (find your file and edit it) and
your talk details at content/talks folder.

For best results, add a squared 137x137 image at the images/avatars/[talk_id]/medium
folder and a thumbnail 49x49 image at the images/avatars/[talk_id]/thumb folder. If
you are going to present with a co-speaker, put his image at images/avatar_cospeakers
folder.

WHAT'S UP SECTION
-----------------

The main page of the website has a list of short news items. You can create them
running `bundle exec rake create:article title='new article' lang='en'` and it will
create the article file in the correct 'content/whatsup' directory.

If you're posting more than 1 news article in the same day, you can use the 'order'
parameter to add a manually incremental number, so the items are properly sorted.
