require 'rails_helper'

shared_examples 'not found' do
  before do
    http_request
  end

  it 'responds with status 404' do
    expect(response).to have_http_status(:not_found)
    expect(response_body).to(
      include('code' => 1002, 'description' => 'NOT_FOUND')
    )
  end
end
