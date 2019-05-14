class Api::V1::UsersController < ApplicationController
  #Dummy controller without auth
  def create
    @user = User.create(user_params)
  end

  def show
    render json: User.find(params[:id])
  end

  def update
    render json: {response: "USERS CONTROLLER UPDATE"}
  end

  private

  def user_params
    #AUTH IT UP
    params.require("user").require("username", "password_digest")
  end
end
