class QuestionController < ApplicationController
  # before_action :authenticate_request!

  def show
    q = Question.find_by(id: params[:question_id]);
    render json: q
  end

  def create
    req_body = JSON.parse(request.body.read)
    q = Question.create(req_body)
    q.update_start_voting_background_job
    render json: q
  end

  def update
    req_body = JSON.parse(request.body.read)
    q = Question.find_by(id: params[:question_id]);
    q.update(req_body)
    q.update_start_voting_background_job
    render json: q
  end

  def showAll
    render json: Question.all
  end
end
