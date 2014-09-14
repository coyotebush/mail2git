Mail2Jekyll
===========

Converts incoming email messages to Jekyll blog posts.

The script expects to receive messages through stdin, and is intended to be attached via pipe to the local MTA (such as [Exim] or [Postfix]). Each message becomes a new file in the `_posts` directory with a name based on the current date and the message subject. This file is then committed to Git with the email sender as the commit author, and the commit is pushed to a remote repository.

Comparison to JekyllMail
--------------------------

[JekyllMail] has a similar function. However, the purpose of Mail2Jekyll is slightly different: while JekyllMail aims to be a fully-featured way to post via email, Mail2Jekyll is intended to create posts from existing mailing list messages. Mail2Jekyll:

 * Doesn't process attachments or metadata
 * Doesn't worry about spam, instead trusting the MTA to filter messages
 * Receives messages through stdin rather than POP3
 * Automatically synchronizes with Git

License
-------
Copyright 2014 [Corey Ford]. Mail2Jekyll is distributed under the terms of the [MIT License].

[Exim]: http://www.exim.org/exim-html-current/doc/html/spec_html/ch-the_pipe_transport.html
[Postfix]: http://www.postfix.org/pipe.8.html
[JekyllMail]: https://github.com/masukomi/JekyllMail
[Corey Ford]: http://www.coreyford.name/
[MIT License]: /LICENSE.md
