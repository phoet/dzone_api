DzoneApi::Application.routes.draw do
  resources :items

  match 'items/:id/vote/:user/:pass' => 'items#vote', :as => :vote_item
  match ':controller(/:action)'

  root :to => "welcome#index"
end
