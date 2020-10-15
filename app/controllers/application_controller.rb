class ApplicationController < ActionController::API
  def encode_token(payload)
    # payload => {beef: "steak"}
    token = JWT.encode(payload, get_secret)
  end

  def decode_token(token)
    payload = JWT.decode(token, get_secret)[0]
  end

  def auth_header
    request.headers["Authorization"]
  end

  def header_token
    if auth_header.present?
      auth_header.split(" ")[1]
    end
  end

  def logged_in?
    if header_token.present?
      payload = decode_token(header_token)
      return User.find(payload["user_id"])
    else
      return false
    end
  end

  def authenticated
    if !logged_in?
      render json: {success: false, message: "User not logged in"}, status: 401
    else
      return true
    end
  end

  private

  def get_secret
    return "Todo: Setup Credentials"
  end
end
