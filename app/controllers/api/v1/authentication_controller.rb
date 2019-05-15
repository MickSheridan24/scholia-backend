class Api::V1::AuthenticationController < ApplicationController
  def authorize
    user = User.find_by(username: auth_params["username"])
    if user && user.authenticate(auth_params["password"])
      render json: {
               success: true,
               username: user.username,
               jwt: encode_token({user_id: user.id}),
             }
    else
      render json: {error: "Username/Password incorrect"}, status: 404
    end
  end

  private

  def auth_params
    params.require("authentication").permit("username", "password")
  end

end
