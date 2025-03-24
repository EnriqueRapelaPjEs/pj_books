require 'rails_helper'

shared_examples 'invalid parameter' do
  before do
    http_request
  end

  it 'responds with status 400' do
    expect(response).to have_http_status(:bad_request)
    expect(response_body).to(
      include('code' => 1007, 'description' => 'INVALID_PARAMETER')
    )
  end
end
