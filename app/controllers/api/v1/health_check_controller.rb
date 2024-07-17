class Api::V1::HealthCheckController < ApplicationController
    def index
        render json: { message: 'healthy!!' }
    end
end
