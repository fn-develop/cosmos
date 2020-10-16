#!/bin/sh

cd /home/futurenet/cosmos
export RAILS_SERVE_STATIC_FILES=1
RAILS_ENV=production
bundle exec rails tmp:clear
bundle exec rails assets:precompile RAILS_ENV=production
bundle exec rails runner Session.clear -e production
bundle exec rails s -e production
