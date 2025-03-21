require 'rails_helper'

describe Api::V1::UsersController do
  describe 'GET #index' do
    subject(:http_request) { get :index }

    let!(:users) { create_list(:user, 5) }

    context 'when success' do
      before do
        http_request
      end

      let(:ids) { users.pluck('id') }

      it 'responds with 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all users paginated' do
        expect(response_body['page'].pluck('id')).to eq(ids)
      end

      it 'uses the model custom serializer' do
        expect(response_body['page'].first).to(have_been_serialized_with(Users::IndexSerializer))
      end
    end
  end

  describe 'GET #show' do
    subject(:http_request) { get :show, params: { id: id } }

    let(:user) { create(:user) }
    let(:id) { user.id }

    context 'when success' do
      before do
        http_request
      end

      it 'responds with 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'is serialized with the correct serializer' do
        expect(response_body).to have_been_serialized_with(Users::ShowSerializer)
      end
    end

    context 'when not found' do
      let(:id) { 0 }

      include_examples 'not found'
    end
  end

  describe 'POST #create' do
    subject(:http_request) { post :create, params: { user: user_params } }

    let(:user_params) { {} }

    context 'when success' do
      let(:user_params) { attributes_for(:user) }

      it 'creates the user' do
        expect { http_request }.to(
          change(User, :count).by(1)
        )
      end

      it 'uses the model default serializer' do
        http_request
        expect(response_body).to have_been_serialized_with(Users::ShowSerializer)
      end

      it 'responds with status 201' do
        expect(http_request).to have_http_status(:created)
      end
    end

    context 'when invalid email' do
      let(:user_params) { attributes_for(:user, email: 'invalid-email') }

      it 'does not create the user' do
        expect { http_request }.not_to(change(User, :count))
      end

      it 'responds with status 422' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when duplicate email' do
      let(:user) { create(:user) }
      let(:user_params) { attributes_for(:user, email: user.email) }

      it 'does not create the user' do
        expect { http_request }.to(change(User, :count).by(1))
      end

      it 'responds with status 422' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when missing params' do
      let(:user_params) { attributes_for(:user, email: nil) }

      it 'does not create the user' do
        expect { http_request }.not_to(change(User, :count))
      end

      it 'responds with status 422' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    subject(:http_request) { patch :update, params: { id: id, user: user_params } }

    let(:user) { create(:user) }
    let(:id) { user.id }
    let(:user_params) { { name: 'New Name' } }

    context 'when success' do
      before { http_request }

      it 'responds with 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the user' do
        expect(user.reload.name).to eq('New Name')
      end

      it 'uses the model default serializer' do
        expect(response_body).to have_been_serialized_with(Users::ShowSerializer)
      end
    end

    context 'when not found' do
      let(:id) { 0 }

      include_examples 'not found'
    end
  end

  describe 'DELETE #destroy' do
    subject(:http_request) { delete :destroy, params: { id: id } }

    let(:user) { create(:user) }
    let(:id) { user.id }

    context 'when success' do
      before { http_request }

      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not found' do
      let(:id) { 0 }

      include_examples 'not found'
    end
  end
end
