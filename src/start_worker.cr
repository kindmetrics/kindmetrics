require "./app"

require "cron_scheduler"
require "logger"

L = Logger.new STDOUT

CronScheduler.define do
  at("* * * * *") { TimeWorker.check }
  at("0 8 * * mon") { EmailWorker.send_report("weekly") }
  at("0 8 1 * *") { EmailWorker.send_report("monthly") }
end

L.info "Scheduler started"

sleep
