module Api
  module V1
    class BookSuggestionsController < ApplicationController
      def index
        render_paginated BookSuggestion.all,
                         each_serializer: BookSuggestions::IndexSerializer
      end

      def show
        render json: book_suggestion,
               serializer: BookSuggestions::ShowSerializer
      end

      def create
        book_suggestion = BookSuggestion.new(book_suggestion_params)
        if book_suggestion.save
          render json: book_suggestion,
                 serializer: BookSuggestions::ShowSerializer
        else
          render json: book_suggestion.errors, status: :unprocessable_entity
        end
      end

      def update
        if book_suggestion.update(book_suggestion_update_params)
          render json: book_suggestion,
                 serializer: BookSuggestions::ShowSerializer
        else
          render json: book_suggestion.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if book_suggestion.destroy
          head :ok
        else
          render json: book_suggestion.errors, status: :unprocessable_entity
        end
      end

      private

      def book_suggestion
        @book_suggestion ||= BookSuggestion.find(params.require(:id))
      end

      def book_suggestion_params
        params.require(:book_suggestion).permit(synopsis: Parameters.string,
                                                price: Parameters.float,
                                                link: Parameters.string,
                                                book_id: Parameters.integer,
                                                user_id: Parameters.integer)
      end

      def book_suggestion_update_params
        params.require(:book_suggestion).permit(synopsis: Parameters.string,
                                                price: Parameters.float,
                                                link: Parameters.string)
      end
    end
  end
end
