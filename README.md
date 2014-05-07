# Introduction

This application provides an API over recommendations provided by the https://github.com/rjlee/kandlcontentpipeline.

# Getting started

* Install heroku toolbelt
* Install RVM and switch to ruby-1.9.3 - rvm use 1.9.3-head
* Install bundler - gem install bundler
* Install gem dependancies - bundle install
* Install mysql/postgres/$rdbms supported by activerecord
* export DATABASE_URL=mysql://user:password@localhost:3306/database (for mysql)
* git clone https://github.com/rjlee/kandlcontentpipeline in the same directory as this project (not inside it)
* rake db:migrate
* rake load
* foreman start
* Load http://localhost:5000/similar?url=http://www.bbc.co.uk/arts/0/23243705 in a client

# Show me more

http://kandlrecommendations.herokuapp.com/similar?url=http://www.bbc.co.uk/guides/zxcbb9q
