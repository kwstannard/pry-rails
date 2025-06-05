TestApp.routes.draw do
  resource :pokemon, :beer
  resources :cars
  namespace :admin do
    resources :cars
    resources :trucks
  end

  get 'exit' => proc { exit! }
  get 'pry' => proc { binding.pry; [200, {}, ['']] }
  root to: 'cars#index'
end
