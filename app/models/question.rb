require "pry"
require "redis"
require 'faye/websocket'
require 'eventmachine'
require 'timeout'

class Question < ApplicationRecord
  attr_accessor :redis_client

  attribute :end_time, :datetime
  attribute :start_time, :datetime
  attribute :question_text, :string
  attribute :answer, :string
  attribute :job_id, :string

  def ws_url
    if Rails.env.production?
      'ws://hivemind-ws.herokuapp.com'
    else
      'ws://localhost:9001'
    end
  end

  def voting_interval
    45
  end

  def redis_client
    if @redis_client
      @redis_client
    else
      @redis_client = Redis.new
      @redis_client.smembers("processes").each do |pro|
        @redis_client.expire(pro, 60)
        @redis_client.expire("#{pro}:workers", 60)
      end
      @redis_client
    end
  end

  def sorted_set_name
    "#{id}-scores"
  end

  def scores
    redis_client.zrevrangebyscore(sorted_set_name, '+inf', 1, { withscores: true })
  end

  def set_next_voting_round_timer
    voting_round_end_time = Time.now + voting_interval.seconds
    job = ChangeVotingWordIdxJob.set(wait_until: voting_round_end_time).perform_later(id)
    update({ job_id: job.job_id })
  end

  def get_winning_word(top_ten)
    tied_for_first = {words: [], score: top_ten[0][1]}

    top_ten.each do |word, score|
      if score == tied_for_first[:score]
        tied_for_first[:words].push(word)
      end
    end

    # if tie for top word, get random choice
    tied_for_first[:words].sample
  end

  def activate_next_voting_round
    puts '~~~~~~~~~activate_next_voting_round~~~~~~~~~'
    # get top 10 words from redis
    top_ten = redis_client.zrevrange(sorted_set_name, 0, 9, { withscores: true })

    winning_word = (!top_ten || !top_ten[0]) ? '' : get_winning_word(top_ten)

    voting_round_end_time = Time.now + voting_interval.seconds

    # check for vote to end answer
    if winning_word == '(complete-answer)'
      voting_round_end_time = nil
      update({ voting_round_end_time: voting_round_end_time, end_time: Time.now })
    else
      # concat winning_word to `question_text`
      new_answer = "#{answer} #{winning_word}".strip
      update({ answer: new_answer, voting_round_end_time: voting_round_end_time })
      set_next_voting_round_timer
    end

    # clear redis
    redis_client.keys("#{id}-*").each { |key| redis_client.del(key) }

    # push update to all WSs
    EM.run {
      ws = Faye::WebSocket::Client.new("#{ws_url}?question=#{id}&vote_next_word=true&winning_word=#{winning_word}&voting_round_end_time=#{voting_round_end_time.to_i * 1000}")

      ws.on :open do |event|
        p [:open]
        sleep 5
        ws.close
      end

      ws.on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end
    }
  end

  def update_start_voting_background_job
    if !job_id.nil?
      # cancel old job (dont know what type it is)
      ChangeVotingWordIdxJob.cancel(job_id)
    end

    if start_time && start_time > Time.now
      # create new job
      job = ChangeVotingWordIdxJob.set(wait_until: start_time).perform_later(id)
      update_columns({
        job_id: job.job_id,
        voting_round_end_time: start_time,
        end_time: nil
      })
    end
  end

end
