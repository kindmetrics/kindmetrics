require "./app"

require "cron_scheduler"
require "logger"

L = Log.for("worker")

CronScheduler.define do
  at("* * * * *") { TimeWorker.check }
  at("0 8 * * mon") { EmailWorker.send_report("weekly") }
  at("0 8 1 * *") { EmailWorker.send_report("monthly") }
  at("0 9 * * *") { TrialReminder.send_reminders }
end

L.info { "Scheduler started" }

sleep
