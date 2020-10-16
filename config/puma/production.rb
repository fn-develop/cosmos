environment ENV.fetch("RAILS_ENV") { "production" }

# UNIX Socketへのバインド
tmp_path = "#{ File.expand_path("../../..", __FILE__) }/tmp"
# bind "unix://#{ tmp_path }/sockets/puma.sock"
port 3000

# スレッド数とWorker数の指定
# MariaDB「show variables like "%max_connections%";」で確認した数値を超えないように設定
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count
# CPUコア数〜1.5倍を基本とする
workers 2
preload_app!

# デーモン化の設定
# daemonize true
# pidfile "#{ tmp_path }/puma.pid"
# stdout_redirect "#{ tmp_path }/puma.stdout.log", "#{ tmp_path }/puma.stderr.log", true
# state_path "#{ tmp_path }/pids/puma.state"

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# puma_worker_killerの設定
before_fork do
  PumaWorkerKiller.config do |config|
    # 閾値を超えた場合にkillする
    config.ram           = 1024 # mb
    config.frequency     = 5 * 60 # per 5minute
    config.percent_usage = 0.9 # 90%
    # 閾値を超えたかどうかに関わらず定期的にkillする
    config.rolling_restart_frequency = 24 * 3600 # per 1day
    # workerをkillしたことをログに残す
    config.reaper_status_logs = true
  end
  PumaWorkerKiller.start
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end
on_worker_boot do
  # 複数のデータベースに接続している時の為
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
