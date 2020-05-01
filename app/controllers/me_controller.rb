class MeController < ApplicationController
  before_action :authenticate_request!

  def show
    render json: current_user.serialize
  end
end
