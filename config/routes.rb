Rails.application.routes.draw do
  get 'common_ancestor', to: 'home#common_ancestor'
  get 'birds', to: 'home#birds'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
