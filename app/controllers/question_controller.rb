class QuestionController < ApplicationController
  before_action :authenticate_request!

  def show
    q = Question.find_by(id: params[:question_id]);
    render json: q
  end

  def create
    if current_user.is_admin
      req_body = JSON.parse(request.body.read)
      q = Question.create(req_body)
      q.update_start_voting_background_job
      render json: q
    else
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end
  end

  def update
    if current_user.is_admin
      req_body = JSON.parse(request.body.read)
      q = Question.find_by(id: params[:question_id]);
      q.update(req_body)
      q.update_start_voting_background_job
      render json: q
    else
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end
  end

  def showAll
    render json: Question.all
  end
end
