module Api
  module V1
    class UsersController < ApplicationController
      def index
        render_paginated User.all,
                         each_serializer: Users::IndexSerializer
      end

      def show
        render json: user,
               serializer: Users::ShowSerializer
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: user,
                 serializer: Users::ShowSerializer,
                 status: :created
        else
          render_validation_error(user)
        end
      end

      def update
        if user.update(user_update_params)
          render json: user,
                 serializer: Users::ShowSerializer
        else
          render_validation_error(user)
        end
      end

      def destroy
        if user.destroy
          head :ok
        else
          render_validation_error(user)
        end
      end

      private

      def user
        @user ||= User.find(params.require(:id))
      end

      def user_params
        params.require(:user).permit(
          email: Parameters.string,
          name: Parameters.string,
          last_name: Parameters.string
        )
      end

      def user_update_params
        params.require(:user).permit(
          name: Parameters.string,
          last_name: Parameters.string
        )
      end
    end
  end
end
