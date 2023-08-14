Rails.application.routes.draw do
  root to: 'pages#home'

  get '/about', to: 'information#about'


  



  devise_for :users

  devise_scope :user do
    get "users", to: "devise/sessions#new"
  end
  
end

=begin
  Lord of my life
  Here is my heartt
  Been so good
  Fear is not my future
  Costly
  One name
  More than Able
  Firm Foundation
  Jehovah
  Yahweh
  Yahweh will Manifest
  Yeshua
  Who is this man?
  Good (can't be anything else)
=end