require 'rails_helper'

describe Api::V1::BooksController do
  describe 'GET #index' do
    subject(:http_request) { get :index }

    let!(:books) { create_list(:book, 5) }

    context 'when success' do
      before do
        http_request
      end

      let(:ids) { books.pluck('id') }

      it 'responds with 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all books paginated' do
        expect(response_body['page'].pluck('id')).to eq(ids)
      end

      it 'uses the model custom serializer' do
        expect(response_body['page'].first).to(have_been_serialized_with(Books::IndexSerializer))
      end
    end
  end

  describe 'GET #show' do
    subject(:http_request) { get :show, params: { id: id } }

    let(:book) { create(:book) }
    let(:id) { book.id }

    context 'with valid parameters' do
      before do
        http_request
      end

      it 'responds with status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'is serialized with the correct serializer' do
        expect(response_body).to have_been_serialized_with(Books::ShowSerializer)
      end
    end

    context 'with invalid parameters' do
      let(:id) { -1 }

      include_examples 'not found'
    end
  end

  describe 'POST #create' do
    subject(:http_request) { post :create, params: { book: book_params } }

    let(:book_params) { {} }

    context 'when creating a book with correct params' do
      let(:book_params) { attributes_for(:book) }

      it 'creates the book' do
        expect { http_request }.to(
          change(Book, :count).by(1)
        )
      end

      it 'uses the model default serializer' do
        http_request
        expect(response_body).to have_been_serialized_with(Books::ShowSerializer)
      end

      it 'responds with status 201' do
        expect(http_request).to have_http_status(:created)
      end
    end

    context 'when creating a book without mandatory param' do
      let(:book_params) { attributes_for(:book, title: nil) }

      it 'does not create the book' do
        expect { http_request }.to change(Book, :count).by(0)
      end

      it 'responds with status 422' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when creating a book with a duplicate title and author' do
      let(:book) { create(:book) }
      let(:book_params) { attributes_for(:book, title: book.title, author: book.author) }

      it 'does not create the book' do
        expect { http_request }.to(change(Book, :count).by(1))
      end

      it 'responds with status 422' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when creating a book with incorrect param type' do
      let(:book_params) { attributes_for(:book, year: 'Invalid year') }

      it 'does not create the book' do
        expect { http_request }.to change(Book, :count).by(0)
      end

      include_examples 'invalid parameter'
    end
  end

  describe 'PATCH #update' do
    subject(:http_request) { patch :update, params: { id: id, book: book_params } }

    let!(:book) { create(:book) }
    let(:id) { book.id }
    let(:book_params) { attributes_for(:book, title: 'Updated title') }

    context 'with all params' do
      before { http_request }

      it 'responds with 200, ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the record with the new data' do
        expect(book.reload.title).to eq('Updated title')
      end

      it 'uses the model default serializer' do
        expect(response_body).to have_been_serialized_with(Books::ShowSerializer)
      end
    end

    context 'with invalid param type' do
      let(:book_params) { attributes_for(:book, year: 'Invalid year') }

      it 'does not create new records' do
        expect { http_request }.to change(Book, :count).by(0)
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

    let(:book) { create(:book) }
    let(:id) { book.id }

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
