class ApplicationController < ActionController::API
    def create_token(user_id)
        payload = {user_id: user_id, exp: (DateTime.current + 14.days).to_i}
        secret_key = Rails.application.credentials.secret_key_base
        token = JWT.encode(payload, secret_key)
        return token
    end
    def authenticate
        authorization_header = request.headers[:authorization]
        if !authorization_header
          render_unauthorized
        else
          token = authorization_header.split(" ")[1]
          secret_key = Rails.application.credentials.secret_key_base
    
          begin
            decoded_token = JWT.decode(token, secret_key)
            @current_user = User.find(decoded_token[0]["user_id"])
          rescue ActiveRecord::RecordNotFound
            render_unauthorized
          rescue JWT::ExpiredSignature
            render json: { errors: 'ExpiredSignature' }, status: :unauthorized
          rescue JWT::DecodeError
            render_unauthorized
          end
        end
    end

    # 未ログイン時
    def render_unauthorized
        render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
end
