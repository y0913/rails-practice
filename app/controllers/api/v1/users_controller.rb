class Api::V1::UsersController < ApplicationController
    before_action :authenticate, only: %i[update]

    def create
        @user = User.new(user_params)
        if @user.save
            render json: {user: {name: @user.name, email: @user.email}}
          else
            render json: {errors: {body: @user.errors}}, status: :unprocessable_entity
          end
    end

    def update
        if @current_user.update(user_params)
          render json: {user: {name: @current_user.name}}
        else 
          render json: {errors: {body: @current_user.errors}}, status: :unprocessable_entity
        end
    end

    private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
