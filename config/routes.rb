Rails.application.routes.draw do
  resources :projects, except: [:new, :edit, :destroy, :show]
  get    '/projects/new',     to: 'projects#new',     as: 'new_project'
  post   '/projects/create',  to: 'projects#create',  as: 'create_project'
  get    '/projects/edit',    to: 'projects#edit',    as: 'edit_project'
  patch  '/projects/update',  to: 'projects#update',  as: 'update_project'
  get    '/projects/destroy', to: 'projects#delete',  as: 'delete_this_project'
  delete '/projects/destroy', to: 'projects#destroy', as: 'destroy_project'
  get    '/projects/show/:id',to: 'projects#show',    as: 'show_project'

  post   '/projects/add_member', to: 'projects#add_member',      as: 'add_member_to_project'
  delete '/projects/lose_member', to: 'projects#remove_member',    as: 'remove_member_from_project'
  root to: 'pages#home'

  get '/about', to: 'information#about'

  devise_for :users

  devise_scope :user do
    get "users", to: "devise/sessions#new"
  end
  
  get '/user/:id', to: 'users#show', as: 'show_user'

end

=begin

  Lord of my life
  Here is my heart
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