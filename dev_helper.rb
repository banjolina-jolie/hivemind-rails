q = Question.first
in_ten_seconds = Time.now + 20.seconds
q.update_start_time(in_ten_seconds)


StartVotingJob.set(wait: 45.seconds).perform_later(q.id)

require 'sidekiq/api'
stats = Sidekiq::Stats.new

sv = Sidekiq::Queue.new('start_voting')
ss = Sidekiq::ScheduledSet.new
ps = Sidekiq::ProcessSet.new


# sv.each do |job|
#   puts job.jid
# end


# nodemon websocket-server.js
# redis-start (aka redis-server /usr/local/etc/redis.conf)
# rails s
# bundle exec sidekiq -q start_voting

tid = nil
w = Sidekiq::Workers.new
w.each do |process_id, thread_id, work, otro|
  # puts process_id
  tid = thread_id
  puts thread_id
  # puts work
  # puts otro
end


# THEYRE NEVER THE SAME AS TID
# Thread.list.each {|t|
#   if t.object_id.to_s(36) == tid
#     # puts t.methods
#     # t.exit
#   end
# }

# Thread.list.map {|t|
#   t.object_id.to_s(36)
# }
