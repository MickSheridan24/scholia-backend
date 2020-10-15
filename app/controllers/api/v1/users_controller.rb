class Api::V1::UsersController < ApplicationController
  before_action :authenticated, only: [:show, :update]

  #POST users/
  def create
    @user = User.create(:username => user_params["username"], password: user_params["password"])

    if (@user.save)
      @user.default_subscriptions
      render json: {
        success: true,
        username: @user.username,
        jwt: encode_token({user_id: @user.id}),
      }
    else
      render json: {error: "Unable to create user"}, status: 404
    end
  end

  #GET users/home
  def show
    @user = logged_in?

    render json: @user
  end

  #PATCH users/:id
  #TODO
  def update
    render json: {response: "USERS CONTROLLER UPDATE"}
  end

  private

  def user_params
    #AUTH IT UP
    params.require("user").permit("username", "password")
  end
end
