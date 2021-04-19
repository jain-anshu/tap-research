# == Route Map
#
#        Prefix Verb   URI Pattern                   Controller#Action
#     campaigns GET    /campaigns(.:format)          campaigns#index
#               POST   /campaigns(.:format)          campaigns#create
#  new_campaign GET    /campaigns/new(.:format)      campaigns#new
# edit_campaign GET    /campaigns/:id/edit(.:format) campaigns#edit
#      campaign GET    /campaigns/:id(.:format)      campaigns#show
#               PATCH  /campaigns/:id(.:format)      campaigns#update
#               PUT    /campaigns/:id(.:format)      campaigns#update
#               DELETE /campaigns/:id(.:format)      campaigns#destroy

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :campaigns, only: [:index] do
    collection do
      get :ordered_campaigns
    end
  end

end
