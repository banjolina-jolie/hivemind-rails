class QuestionController < ApplicationController
  def show
    q = Question.find_by(id: params[:question_id]);
    render json: q
  end
end
