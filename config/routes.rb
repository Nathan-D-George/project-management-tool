Rails.application.routes.draw do
  get    '/projects/new',     to: 'projects#new',     as: 'new_project'
  post   '/projects/create',  to: 'projects#create',  as: 'create_project'
  get    '/projects/edit',    to: 'projects#edit',    as: 'edit_project'
  patch  '/projects/update',  to: 'projects#update',  as: 'update_project'
  delete '/projects/destroy', to: 'projects#destroy', as: 'destroy_projects'
  get    '/projects/show/:id',to: 'projects#show',    as: 'show_project'

  post   '/projects/add_members', to: 'projects#add_members',      as: 'add_member_to_project'

  # post 'add_member_to_project', to: 'participants#add_member_to_project'

  root to: 'pages#home'

  get '/about', to: 'information#about'

  devise_for :users

  devise_scope :user do
    get "users", to: "devise/sessions#new"
  end
  
  # get '/user/:id', to: 'users#show', as: 'user'

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