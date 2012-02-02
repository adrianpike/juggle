juggle
======

Juggle is a tool for managing different software projects. Every time I bounce between a different project, I have a bunch of overhead. There's lots of tools to ease parts of this pain, but I still have to use them.

That's where Juggle comes in to help me Juggle my projects.

  $ jug example_project

Magic happens, and example_project's environment is set up.

  $ jug issues

Kaboom, I'm in the issue tracker for example_project! Might be github, might be Pivotal.

  $ jug basecamp
  $ jug github

Should be self explanatory.

  $ jug another_project
  
And now I'm ready to rock for another_project. 
Maybe a Redis server is started. I'm in another\_project's directory. Something might have been cleaned up for example\_project. basically, magic.

*It's not done yet. Please don't use it unless you're ready to wade through the jungle of unfinished and ugly code.*

How it works
------------

Juggle uses a _jugfile_, which (by default) lives in ~/.jugfile. It's a jsonified representation of the projects and resources that you've told Juggle about, as well as some info about who you are, and what the last project you were in was.

When you ask to switch to a project:
* If you're in an existing project, Juggle fires off the teardown calls on resources that you've specified for the old project.
* Juggle fires off the startup calls on resources that you've specified for the new project.

Resources can have both a startup & shutdown call, and can be called automatically, or only on user input. Good examples of automatic resources would be Redis, Thin, Guard, or your node.js server, and good examples of user-controlled resources would be URLs to your issue tracker, CI server, or time clock.

It's really easy to write your own resources - Juggle comes with a bunch of default types, and will autoload any Ruby files that you put in ~/.juggle/resources/.

Quickstart
----------

  gem install juggle ## advice: do this in your rvm @global gemset.
  cd my_awesome_project
  jug add my_awesome_project
  jug edit my_awesome_project
  
Juggle will autoscan your current directory for interesting clues, and try and build a sane project around it. You should now jug edit to make it your own.

Example jugfile project
-----------------------

Here's a totally pointless demo:

    {
      "name": "test123",
      "cwd": "/Users/adrian/Dropbox/src/juggle",
      "resources": {
        "google": {
          "autostart": false,
          "kind": "Url",
          "opts": {
            "url": "http://google.com/"
          }
        }
      }
    }

On CWDs
-------

Jug can't change your CWD for you without a little work. There's another executable called jug\_cd, which returns a command to change to the cwd of the active Juggle project. There's a bunch of ways to make this work for you - jug amazing\_project && `jug\_cd` is one way.

If you want it to be magical, put this at the end of your .bashrc:

  function jugg() { jug "$@" && `jug_cd`; }
  
Writing & using resources
-----------------

Take a look at juggle/resource/url.rb for a simple example. It should be pretty self-explanatory.

Contributing to juggle
----------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2012 Adrian Pike. See LICENSE.txt for
further details.

