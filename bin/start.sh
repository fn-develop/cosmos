#!/bin/sh

cd /home/futurenet/cosmos
export RAILS_SERVE_STATIC_FILES=1
#export MAIL_SEND_ON=1 # 本番環境でコメントを外す
RAILS_ENV=production
bundle exec rails tmp:clear
bundle exec rails assets:precompile
bundle exec rails runner Session.clear -e production
bundle exec rails s -e production
