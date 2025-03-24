module Api
  module V1
    class RentsController < ApplicationController
      def index
        render_paginated Rent.all,
                         each_serializer: Rents::IndexSerializer
      end

      def show
        render json: rent,
               serializer: Rents::ShowSerializer
      end

      def create
        result = Rents::GenerateCreate.call(rent_params)
        if result.success?
          render json: result.rent,
                 serializer: Rents::ShowSerializer,
                 status: :created
        else
          render_error(result.error)
        end
      end

      def update
        result = ::Books::CheckBookAvailability.call(rent_update_params)

        if result.success?
          handle_successful_update
        else
          render_error(result.error)
        end
      end

      def destroy
        if rent.destroy
          head :ok
        else
          render_validation_error(rent)
        end
      end

      private

      def rent
        @rent ||= Rent.find(params.require(:id))
      end

      def rent_params
        params.require(:rent).permit(
          book_id: Parameters.integer,
          user_id: Parameters.integer,
          start_date: Parameters.date,
          end_date: Parameters.date
        )
      end

      def rent_update_params
        params.require(:rent).permit(
          book_id: Parameters.integer,
          start_date: Parameters.date,
          end_date: Parameters.date
        )
      end

      def handle_successful_update
        if rent.update(rent_update_params)
          render json: rent,
                 serializer: Rents::ShowSerializer,
                 status: :created
        else
          render_validation_error(rent)
        end
      end
    end
  end
end
