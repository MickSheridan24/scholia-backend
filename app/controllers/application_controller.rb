class ApplicationController < ActionController::API
  def encode_token(payload)
    # payload => {beef: "steak"}
    token = JWT.encode(payload, get_secret)
  end

  def decode_token(token)
    payload = JWT.decode(token, get_secret)[0]
  end

  def get_secret
    return "shhh, it's a secret"
  end
end
