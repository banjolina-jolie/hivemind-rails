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

  def redis_client
    @redis_client = @redis_client || Redis.new
    @redis_client
  end

  def scores
    redis_client.zrevrangebyscore(sorted_set_name, '+inf', 1, { withscores: true })
  end

  def sorted_set_name
    "#{id}-scores"
  end

  def activate_voting
    in_thirty_sec = Time.now + 30.seconds
    job = ChangeVotingWordIdxJob.set(wait: 30.seconds).perform_later(id)
    update({ job_id: "#{job_id} #{job.job_id}", voting_round_end_time: in_thirty_sec})

    EM.run {
      ws = Faye::WebSocket::Client.new("wss://hivemind-ws.herokuapp.com?question=#{id}&start=true&voting_round_end_time=#{in_thirty_sec}")

      ws.on :open do |event|
        p [:open]
        sleep 10
        ws.close
      end

      ws.on :close do |event|
        ws = nil
        p [:close, event.code, event.reason]
      end
    }

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

  def vote_next_word
    # get top 10 words from redis
    top_ten = redis_client.zrevrange(sorted_set_name, 0, 9, { withscores: true })

    winning_word = (!top_ten || !top_ten[0]) ? '<NO_VOTES>' : get_winning_word(top_ten)

    in_thirty_sec = Time.now + 30.seconds

    # check for vote to end answer
    if winning_word == '<END_SENTENCE>'
      update({ voting_round_end_time: nil, end_time: Time.now })
    else
      # concat winning_word to `question_text`
      new_answer = "#{answer} #{winning_word}"
      job = ChangeVotingWordIdxJob.set(wait: 30.seconds).perform_later(id)
      update({ answer: new_answer, job_id: "#{job_id} #{job.job_id}", voting_round_end_time: in_thirty_sec })
    end

    # clear redis
    redis_client.keys("#{id}-*").each { |key| redis_client.del(key) }

    # push update to all WSs
    EM.run {
      ws = Faye::WebSocket::Client.new("wss://hivemind-ws.herokuapp.com?question=#{id}&vote_next_word=true&winning_word=#{winning_word}&voting_round_end_time=#{in_thirty_sec}")

      ws.on :open do |event|
        p [:open]
        sleep 10
        ws.close
      end

      ws.on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end
    }
  end

  def update_start_time(start_time)
    update({
      answer: nil,
      end_time: nil,
      start_time: start_time,
      voting_round_end_time: start_time,
      job_id: nil,
    })
    update_start_voting_background_job
  end

  def update_start_voting_background_job
    # if !job_id.nil?
    #   # cancel old job
    #   StartVotingJob.cancel(job_id)
    # end

    if start_time && start_time > Time.now
      # create new job
      job = StartVotingJob.set(wait_until: start_time).perform_later(id)
      update({ job_id: job.job_id})
    else
      # clear job_id
      update({ job_id: nil})
    end
  end

end
