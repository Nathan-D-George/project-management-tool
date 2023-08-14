Rails.application.routes.draw do
  root to: 'pages#home'

  get '/about', to: 'information#about'

  
  



  devise_for :users

  devise_scope :user do
    get "users", to: "devise/sessions#new"
  end
  
end
