class UserController < ApplicationController
  def create
    # TODO: email verification / password changing etc
    req_body = JSON.parse(request.body.read)
    u = User.create(req_body)
    render json: u.auth_payload
  end
end
