# MVS School Management System

[![Build Status](https://travis-ci.org/mvs-singapore/mvs-sms.svg?branch=master)](https://travis-ci.org/mvs-singapore/mvs-sms)

[![Issue Count](https://codeclimate.com/github/mvs-singapore/mvs-sms/badges/issue_count.svg)](https://codeclimate.com/github/mvs-singapore/mvs-sms)

## Development Installation

### Option A: Install on Cloud9

- Update Ruby to 2.4.1

  ```
  rvm install 2.4.1
  rvm --default use 2.4.1
  ```

- Install Rails 5

  ```
  gem install rails
  ```

- Check out this repository to your Cloud9 IDE workspace.
- Replace `workspace` folder with this folder.

### Option B: Install Ruby & Rails on your local machine

- Here's the guide to doing it on MacOS: https://github.com/CoderKungfu/polyglot-starter-kit/tree/master/ruby

## Email Delivery

### Local Development

We use [Mailcatcher](https://mailcatcher.me) to receive emails sent in local development.

To install Mailcatcher:

```
gem install mailcatcher --no-ri --no-rdoc
```

To start mailcatcher:

```
mailcatcher
```

Visit the inbox here: [http://localhost:1080](http://localhost:1080)

To stop mail catcher, just click on "Quit" in the web interface.

### Staging Server

Visit the MailTrap inbox here: [https://heroku.mailtrap.io/inboxes/243584/messages](https://heroku.mailtrap.io/inboxes/243584/messages)

## Contributors

- Michael Cheng
- Lian Tong Wei
- Pearly Ong
- Marta Stanke
- Anukrity Jain
- Gia Phua
- Emily Ong
