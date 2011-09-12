RUBYCONF BRASIL
===============

This is the source code for the RubyConf Brasil Website. It is based on the
excellent [nanoc3](http://nanoc.stoneship.org) static site generator.

INSTALL
-------

You need to have Ruby installed and the [Bundler](http://gembundler.com/) gem.

Then just run `bundler` to install the dependencies and `bundle exec nanoc3 compile`.
This will generate the entire website in the 'output' directory.

You can now run `bundle exec nanoc3 view` to run the Webrick web server and
see the generated website opening a web browser pointing to http://localhost:3000
