
<p align="center">
  <img alt="vscode logo" src="./devsnest.png" width="100px" />
  <h1 align="center">Devsnest's Backend</h1>
</p>

![workflow](https://github.com/devs-nest/backend/actions/workflows/ruby.yml/badge.svg)

Uses:  
<p align="left">
<img alt="Ruby" src="https://img.shields.io/static/v1?label=Ruby&message=2.7.2&color=red"/>
<img alt="MySQL" src="https://img.shields.io/static/v1?label=MySQL&message=8.0&color=blue"/>
<img alt="Rails" src="https://img.shields.io/static/v1?label=Rails&message=6&color=red"/>
</p>

# Installation
If you don't have build tools installed (gcc, make etc) install them.
```bash
$ sudo apt install build-essential
```
Install ruby using rbenv.
```bash
$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv

$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc

$ exec $SHELL

$ git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

$ rbenv install 2.7.2

$ rbenv global 2.7.2

$ ruby -v
```

Install bundle and rails
```bash
# Arch users can skip first command
$ sudo apt-get install -y libreadline-dev zlib1g-dev

$ gem install bundler

$ gem install rails

$ rbenv rehash

$ rails -v
```
Install MySQL
> Ubuntu
```bash
$ sudo apt install mysql-server

$ sudo /etc/init.d/mysql start
# check this issue if it gives error
# https://github.com/wslutilities/wslu/issues/101

$ sudo mysql_secure_installation
```
> Arch
```bash
$ sudo pacman -S mariadb

$ sudo /etc/init.d/mysql start
# If you get an error run next 2 commands otherwise skip

$ sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

$ sudo systemctl start mysqld

$ sudo mysql_secure_installation
```
> ALWAYS use a password containing uppercase, lowercase,  and special characters or else MySQL will give error (eg. Test@1234)

# Setup
Clone the repository.
```bash
$ git clone git@github.com:devs-nest/backend.git

$ cd backend/devsnest
```
Setup `.env` file and run.
```bash
$ bundle install

$ bundle exec rake db:create db:migrate db:seed

$ rails s -p 8000
```
# Common Errors

If you get a MySQL error during `bundle install`
```bash
$ sudo apt-get install libmysql-ruby libmysqlclient-dev
```
If you are on WSL, you might get a Network Error while doing auth with discord, it is likely that IPv6 is causing it so disable it

## Environment Variables
| KEY | VALUE |
|---|---|
| MYSQL_NAME | Database Name |
| MYSQL_USERNAME | Username for MySQL |
| MYSQL_PASSWORD | Password for MySQL |
| MYSQL_HOST | Hostname for MySQL |
| AWS_SECRET_KEY |  |
| DEVISE_JWT_SECRET_KEY |  |
| DISCORD_TOKEN |  |
| SENTRY_DSN |  |
| RAILS_ENV | Type of rails environment  |
| SECRET_KEY_BASE |  |
| DISCORD_CLIENT_ID | Client id of discord bot |
| DISCORD_CLIENT_SECRET | Client secret of discord bot |
| FRONTEND_URL | Frontend url |
| DISCORD_REDIRECT_URI | URL to redirect to after discord login |
| NEW_RELIC_KEY | Key for New Relic |




# Resources
* JSON API Resources https://jsonapi-resources.com/v0.10/guide/
* Devise JWT https://github.com/waiting-for-dev/devise-jwt


## POSTMAN Collection link
* https://www.getpostman.com/collections/c153b9df120f4d08e7b5
