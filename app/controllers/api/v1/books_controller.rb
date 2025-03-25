module Api
  module V1
    class BooksController < ApplicationController
      def index
        render_paginated Book.all,
                         each_serializer: Books::IndexSerializer
      end

      def show
        render json: book,
               serializer: Books::ShowSerializer
      end

      def create
        book = Book.new(book_params)
        if book.save
          render json: book,
                 serializer: Books::ShowSerializer,
                 status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end

      def update
        if book.update(book_params)
          render json: book,
                 serializer: Books::ShowSerializer
        else
          render_validation_error(book)
        end
      end

      def destroy
        if book.destroy
          head :ok
        else
          render_validation_error(book)
        end
      end

      def by_isbn
        result = Books::ByIsbn.call(params.permit(isbn: Parameters.string))
        if result.success?
          render json: result.book_hash
        else
          render_error(result.error)
        end
      end

      private

      def book
        @book ||= Book.find(params.require(:id))
      end

      def book_params
        params.require(:book)
              .permit(genre:     Parameters.string,
                      author:    Parameters.string,
                      image:     Parameters.string,
                      title:     Parameters.string,
                      publisher: Parameters.string,
                      year:      Parameters.integer)
      end
    end
  end
end
