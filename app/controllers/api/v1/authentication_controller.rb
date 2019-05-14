class Api::V1::AuthenticationController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      render json: {
               id: user.id,
               username: user.username,
               jwt: encode_token({user_id: user.id}),
             }
    else
      render json: {error: "Username/Password incorrect"}, status: 404
    end
  end
end
