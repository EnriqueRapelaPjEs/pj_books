class ApplicationController < ActionController::API
  include Wor::Paginate
  include ErrorsHelper
end
