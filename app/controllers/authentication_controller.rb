class AuthenticationController < ApplicationController
  def authenticate_user
    req_body = JSON.parse(request.body.read)

    user = User.find_for_database_authentication(email: req_body["email"])
    if user && user.valid_password?(req_body["password"])
      render json: user.auth_payload
    else
      render json: {errors: ['Invalid phone number or password']}, status: :unauthorized
    end
  end

end
