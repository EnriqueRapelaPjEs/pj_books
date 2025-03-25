require 'rails_helper'

describe Api::V1::RentsController do
  include ActiveJob::TestHelper

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe 'GET #index' do
    subject(:http_request) { get :index }

    let!(:rents) { create_list(:rent, 5) }

    context 'when success' do
      before do
        http_request
      end

      let(:ids) { rents.pluck('id') }

      it 'responds with 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all books paginated' do
        expect(response_body['page'].pluck('id')).to eq(ids)
      end

      it 'uses the model custom serializer' do
        expect(response_body['page'].first).to(have_been_serialized_with(Rents::IndexSerializer))
      end
    end
  end

  describe 'GET #show' do
    subject(:http_request) { get :show, params: { id: id } }

    let(:rent) { create(:rent) }
    let(:id) { rent.id }

    context 'with valid parameters' do
      before do
        http_request
      end

      it 'responds with status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'is serialized with the correct serializer' do
        expect(response_body).to have_been_serialized_with(Rents::ShowSerializer)
      end
    end

    context 'with invalid parameters' do
      let(:id) { -1 }

      include_examples 'not found'
    end
  end

  describe 'POST #create' do
    subject(:http_request) { post :create, params: { rent: rent_params } }

    let(:rent_params) { {} }

    context 'when creating a rent with correct params' do
      let(:book) { create(:book) }
      let(:user) { create(:user) }
      let(:rent_params) { attributes_for(:rent, book_id: book.id, user_id: user.id) }

      it 'creates the rent' do
        expect { http_request }.to(
          change(Rent, :count).by(1)
        )
      end

      it 'uses the model default serializer' do
        http_request
        expect(response_body).to have_been_serialized_with(Rents::ShowSerializer)
      end

      it 'responds with status 201' do
        expect(http_request).to have_http_status(:created)
      end

      it 'enqueues the email job' do
        expect { http_request }.to have_enqueued_job(SendRentConfirmationEmailJob)
      end
    end

    context 'when creating a rent without mandatory param' do
      let(:book) { create(:book) }
      let(:user) { create(:user) }
      let(:rent_params) { attributes_for(:rent, book_id: book.id, user_id: user.id, start_date: nil) }

      it 'does not create the rent' do
        expect { http_request }.to change(Rent, :count).by(0)
      end

      include_examples 'invalid parameter'
    end

    context 'when creating a rent with end_date before start_date' do
      let(:rent) { create(:rent) }
      let(:book) { create(:book) }
      let(:user) { create(:user) }
      let(:rent_params) do
        attributes_for(:rent, start_date: rent.start_date, end_date: rent.start_date - 1.day, book_id: book.id,
       user_id: user.id)
      end

      it 'responds with status 422' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when creating a rent with incorrect param type' do
      let(:rent_params) { attributes_for(:rent, start_date: 'Invalid start date') }

      it 'does not create the rent' do
        expect { http_request }.to change(Rent, :count).by(0)
      end

      include_examples 'invalid parameter'
    end

    context 'when creating a rent with an invalid book id' do
      let(:rent_params) { attributes_for(:rent, book_id: -1) }

      include_examples 'not found'
    end

    context 'when creating a rent with an invalid user id' do
      let(:rent_params) { attributes_for(:rent, user_id: -1) }

      include_examples 'not found'
    end

    context 'when creating a rent with an existing rent in the same period' do
      let(:rent) { create(:rent) }
      let(:rent_params) do
        attributes_for(:rent, start_date: rent.start_date, end_date: rent.end_date, book_id: rent.book_id,
       user_id: rent.user_id)
      end

      it 'does not create the rent' do
        expect { http_request }.to change(Rent, :count).by(1)
      end

      it 'responds with status 400' do
        expect(http_request).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PATCH #update' do
    subject(:http_request) { patch :update, params: { id: id, rent: rent_params } }

    let!(:rent) { create(:rent) }
    let(:id) { rent.id }
    let(:rent_params) { attributes_for(:rent) }

    context 'with all params' do
      before { http_request }

      it 'responds with 201' do
        expect(response).to have_http_status(:created)
      end

      it 'updates the record with the new data' do
        expect(rent.reload.start_date).to eq(rent_params[:start_date])
        expect(rent.reload.end_date).to eq(rent_params[:end_date])
      end

      it 'uses the model default serializer' do
        expect(response_body).to have_been_serialized_with(Rents::ShowSerializer)
      end
    end

    context 'with invalid param type' do
      let(:rent_params) { attributes_for(:rent, start_date: 'Invalid start date') }

      it 'does not create new records' do
        expect { http_request }.to change(Rent, :count).by(0)
      end

      include_examples 'invalid parameter'
    end

    context 'with invalid id' do
      let(:id) { -1 }

      include_examples 'not found'
    end

    context 'when updating a rent with an invalid book id' do
      let(:rent_params) { attributes_for(:rent, book_id: -1) }

      it 'responds with status 422' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when updating a rent with an existing rent in the same period' do
      let(:rent) { create(:rent) }
      let(:rent_params) do
        attributes_for(:rent, start_date: rent.start_date, end_date: rent.end_date, book_id: rent.book_id,
       user_id: rent.user_id)
      end

      it 'does not update the rent' do
        expect { http_request }.to(change(Rent, :count).by(0))
      end

      it 'responds with status 400' do
        expect(http_request).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:http_request) { delete :destroy, params: { id: id } }

    let(:rent) { create(:rent) }
    let(:id) { rent.id }

    context 'when success' do
      before do
        http_request
      end

      it 'responses with ok' do
        expect(http_request).to have_http_status(:ok)
      end
    end

    context 'with an invalid rent id' do
      let(:id) { -1 }

      include_examples 'not found'
    end
  end

  after do
    clear_enqueued_jobs
  end
end
