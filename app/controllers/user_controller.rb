class UserController < ApplicationController
  def create
    req_body = JSON.parse(request.body.read)
    u = User.create(req_body)
    render json: u
  end
end
