##.Mail

.Mail is an open source project designed to make email beautiful and functional again.  It is a front-end GUI over top of many powerful 3rd party libraries like MailCore2, ReactiveCocoa and our own Puissant.  .Mail implements all the major email protocols: POP, IMAP and SMTP and hides implementation details, and quite a bit of error handling, behind a smart backend to make using the application as painless and smooth as possible.

##Installation
(If necessary, remove the build folder from any previous iterations of DotMail)

- Run 

```Shell
$ git clone --recursive https://github.com/DotMail/DotMail.git ; cd DotMail ;  git submodule update -i --recursive
$ ./External/Puissant/External/ReactiveCocoa/script/bootstrap
```

- After all the dependencies have been resolved and downloaded, open the enclosed Xcode Project.
- Select DotMail from the schemes drop-down.
- Select Run.

##Contributing
If you find a bug (which you totally won’t), report it!  If you know how to fix it, open a pull request.  

##Contact
If you have any questions, comments, or want to contribute, you can reach me on Twitter [@CodaFi_](https://twitter.com/CodaFi_)

##License
DotMail is available under the MIT open source license.  See LICENSE.md for more details.

Please don’t distribute commercially without prior consent!
