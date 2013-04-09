Mapmyenergy::Application.routes.draw do
  resources :homes
  root :to => 'homes#landing'
end
