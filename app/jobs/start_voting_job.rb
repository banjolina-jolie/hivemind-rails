class StartVotingJob < ApplicationJob
  queue_as :start_voting

  # sidekiq_options retry: 5
  sidekiq_options retry: false

  def perform(question_id)
    begin
      puts 'PERFORM START VOTING'
      q = Question.find(question_id)
      diff = (q.start_time.to_i - Time.now.to_i).abs
      puts diff
      if diff <= 10
        q.activate_voting
      end
      true
    rescue StandardError => e
      puts e.message
      puts e.backtrace.inspect
    end

    true
  end
end
