Rails.application.routes.draw do
  devise_for :users, :controllers => {sessions: 'sessions'}

  root to: "pages#index"
  get "/protected", to: "pages#protected"

  #mount DeviseCapturable::Engine => "/devise_capturable"
  mount Devise::Capturable::Rails::Engine => "/devise_capturable"
end
