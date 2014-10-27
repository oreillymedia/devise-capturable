Rails.application.routes.draw do

  #mount DeviseCapturable::Engine => "/devise_capturable"
  mount Devise::Capturable::Rails::Engine => "/devise_capturable"
end
