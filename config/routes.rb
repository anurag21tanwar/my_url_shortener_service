Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/stats', to: 'shortened_urls#stats'
  post '/create', to: 'shortened_urls#create'
  get '/:id', to: 'shortened_urls#show'
end
