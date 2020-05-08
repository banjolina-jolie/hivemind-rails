class HomeController < ApplicationController
  def show
    active_question = Question
                        .where.not(start_time: nil)
                        .where(end_time: nil)
                        .sort_by(&:start_time)
                        .try(:first)

    previous_questions = Question.where.not(end_time: nil).sort_by(&:start_time).first(5)
    render json: { active_question: active_question, previous_questions: previous_questions }
  end
end
