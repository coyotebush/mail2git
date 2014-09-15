mail2git
===========

Converts incoming email messages to files in a Git repository.

mail2git expects to receive messages through stdin, so it can be attached via pipe to the local MTA (such as [Exim] or [Postfix]). The message becomes a new file in the Git repository, with filename and content based on templates. This is then committed with the email sender as the commit author, and the commit is pushed to a remote repository.

Initially designed for use with Jekyll blog posts.

Configuration
-------------
Requires CMake and `pkg-config` for [Rugged]'s included libgit2. Install dependencies using `bundle install`.

Edit `config.yml` to set the location of the Git repository, [Liquid] templates for file path and content, etc.

Comparison to JekyllMail
--------------------------

[JekyllMail] is another way to convert emails to Jekyll blog posts. mail2git:

 * Doesn't process attachments or metadata
 * Doesn't worry about spam, instead trusting the MTA to filter messages
 * Receives messages through stdin rather than POP3
 * Uses Git instead of the filesystem

License
-------
Copyright 2014 [Corey Ford]. mail2git is distributed under the terms of the [MIT License].

[Exim]: http://www.exim.org/exim-html-current/doc/html/spec_html/ch-the_pipe_transport.html
[Postfix]: http://www.postfix.org/pipe.8.html
[Rugged]: https://github.com/libgit2/rugged
[Liquid]: https://github.com/Shopify/liquid
[JekyllMail]: https://github.com/masukomi/JekyllMail
[Corey Ford]: http://www.coreyford.name/
[MIT License]: /LICENSE.md
