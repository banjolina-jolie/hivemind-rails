class ChangeVotingWordIdxJob < ApplicationJob
  queue_as :start_voting

  # sidekiq_options retry: 5
  sidekiq_options retry: false

  def perform(question_id)
    begin
      puts 'PERFORM CHANGE VOTING'
      q = Question.find(question_id)

      if q.voting_round_end_time
        q.vote_next_word
      end
      true
    rescue StandardError => e
      puts 'change shit fucked'
      puts 'change shit fucked'
      puts 'change shit fucked'
      puts e.message
      puts e.backtrace.inspect
    end
  end
end