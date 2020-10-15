class Api::V1::AuthenticationController < ApplicationController

  #POST /login
  def authorize
    user = User.find_by(username: auth_params["username"])
    byebug
    if user && user.authenticate(auth_params["password"])
      render json: {
               success: true,
               username: user.username,
               id: user.id,
               jwt: encode_token({user_id: user.id}),
             }
    else
      render json: {success: false, error: "Username/Password incorrect"}
    end
  end

  private

  def auth_params
    params.require("authentication").permit("username", "password")
  end
end
