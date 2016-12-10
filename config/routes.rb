Rails.application.routes.draw do
  root to: 'tasklist#home'
  post '/', to: 'tasklist#create'
  post '/:slug', to: 'task#create'
  put '/:slug/:id', to: 'task#update'
  get '/:slug', to: 'tasklist#show'
  put '/:slug', to: 'tasklist#update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
