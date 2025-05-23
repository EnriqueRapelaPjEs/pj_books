Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :books do
        collection do
          get :by_isbn
        end
      end
      resources :users
      resources :rents
      resources :book_suggestions
    end
  end
end
