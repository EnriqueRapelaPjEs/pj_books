require 'rails_helper'

describe Api::V1::BookSuggestionsController do
  describe 'GET #index' do
    subject(:http_request) { get :index }

    let!(:book_suggestions) { create_list(:book_suggestion, 5) }

    context 'when success' do
      before do
        http_request
      end

      let(:ids) { book_suggestions.pluck('id') }

      it 'responds with 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all book suggestions paginated' do
        expect(response_body['page'].pluck('id')).to eq(ids)
      end

      it 'uses the model custom serializer' do
        expect(response_body['page'].first).to(have_been_serialized_with(BookSuggestions::IndexSerializer))
      end
    end
  end

  describe 'GET #show' do
    subject(:http_request) { get :show, params: { id: id } }

    let(:book_suggestion) { create(:book_suggestion) }
    let(:id) { book_suggestion.id }

    context 'with valid parameters' do
      before do
        http_request
      end

      it 'responds with status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'is serialized with the correct serializer' do
        expect(response_body).to have_been_serialized_with(BookSuggestions::ShowSerializer)
      end
    end

    context 'with invalid parameters' do
      let(:id) { -1 }

      include_examples 'not found'
    end
  end

  describe 'POST #create' do
    let(:book) { create(:book) }
    let(:user) { create(:user) }
    subject(:http_request) { post :create, params: { book_suggestion: book_suggestion_params } }

    let(:book_suggestion_params) { { book_id: book.id, user_id: user.id, link: 'https://example.com', price: 10.0, synopsis: 'This is a test synopsis' } }

    context 'when creating a book suggestion with correct params' do
      it 'creates the book suggestion' do
        expect { http_request }.to(
          change(BookSuggestion, :count).by(1)
        )
      end

      it 'uses the model default serializer' do
        http_request
        expect(response_body).to have_been_serialized_with(BookSuggestions::ShowSerializer)
      end

      it 'responds with status 201' do
        expect(http_request).to have_http_status(:ok)
      end
    end

    context 'when creating a book without mandatory param' do
      let(:book_suggestion_params) { attributes_for(:book_suggestion, link: nil) }

      it 'does not create the book suggestion' do
        expect { http_request }.to change(BookSuggestion, :count).by(0)
      end

      it 'responds with status 422' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when creating a book suggestion with incorrect param type' do
      let(:book_suggestion_params) { attributes_for(:book_suggestion, price: 'Invalid price') }

      it 'does not create the book suggestion' do
        expect { http_request }.to change(BookSuggestion, :count).by(0)
      end

      include_examples 'invalid parameter'
    end
  end

  describe 'PATCH #update' do
    subject(:http_request) { patch :update, params: { id: id, book_suggestion: book_suggestion_params } }

    let!(:book_suggestion) { create(:book_suggestion) }
    let(:id) { book_suggestion.id }
    let(:book_suggestion_params) { attributes_for(:book_suggestion, synopsis: 'Updated synopsis') }

    context 'with all params' do
      before { http_request }

      it 'responds with 200, ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the record with the new data' do
        expect(book_suggestion.reload.synopsis).to eq('Updated synopsis')
      end

      it 'uses the model default serializer' do
        expect(response_body).to have_been_serialized_with(BookSuggestions::ShowSerializer)
      end
    end

    context 'with invalid param type' do
      let(:book_suggestion_params) { attributes_for(:book_suggestion, price: 'Invalid price') }

      it 'does not create new records' do
        expect { http_request }.to change(BookSuggestion, :count).by(0)
      end

      include_examples 'invalid parameter'
    end

    context 'with invalid id' do
      let(:id) { -1 }

      include_examples 'not found'
    end
  end

  describe 'DELETE #destroy' do
    subject(:http_request) { delete :destroy, params: { id: id } }

    let(:book_suggestion) { create(:book_suggestion) }
    let(:id) { book_suggestion.id }

    context 'when success' do
      before do
        http_request
      end

      it 'responses with ok' do
        expect(http_request).to have_http_status(:ok)
      end
    end

    context 'with an invalid book id' do
      let(:id) { -1 }

      include_examples 'not found'
    end
  end
end
