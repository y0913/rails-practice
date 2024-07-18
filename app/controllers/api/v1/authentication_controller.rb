class Api::V1::AuthenticationController < ApplicationController
    def login
        @user = User.find_by_email(params[:user][:email])
        # has_secure_passwordのメソッド
        if @user&.authenticate(params[:user][:password])
          token = create_token(@user.id)
          render json: {user: {email: @user.email, token: token, name: @user.name}}
        else
          render status: :unauthorized
        end
    end
end
