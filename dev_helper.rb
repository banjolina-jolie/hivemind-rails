q = Question.first
in_ten_seconds = Time.now + 20.seconds
q.update_start_time(in_ten_seconds)




require 'sidekiq/api'
stats = Sidekiq::Stats.new


sv = Sidekiq::Queue.new('start_voting')
sv.each do |job|
  puts job.jid
end


# Sidekiq::Queue.all.each {|q| q.clear}


# nodemon websocket-server.js
# redis-server /usr/local/etc/redis.conf
# rails s
# bundle exec sidekiq -q start_voting

tid = nil
workers = Sidekiq::Workers.new
workers.each do |process_id, thread_id, work, otro|
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
