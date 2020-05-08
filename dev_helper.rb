# q = Question.first
# q = Question.find('f6e73077-6e44-452f-adf4-d97a5d134b36')


q = Question.where.not(end_time: nil).sort_by(&:start_time).last
q = Question.where(end_time: nil).sort_by(&:start_time).try(:first)
new_start_time = Time.now + 10.seconds
q.update({
  answer: nil,
  start_time: new_start_time,
})
q.update_start_voting_background_job


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

# tids = ['ow1enimjv', 'ow1enio1r']
# Thread.list.each {|t|
#   if tids.include?(t.object_id.to_s(36))
#     t.exit
#   end
# }

w.each do |process_id, thread_id, work, otro|
  # puts process_id
  # puts thread_id
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
