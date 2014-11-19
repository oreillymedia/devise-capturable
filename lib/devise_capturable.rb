require 'devise'

require 'devise_capturable/model'
require 'devise_capturable/strategy'
Warden::Strategies.add(:capturable, Devise::Capturable::Strategies::Capturable)
require 'devise_capturable/view_helpers'
require 'devise_capturable/routes'

module Devise
  mattr_accessor :capturable_server
  mattr_accessor :capturable_client_id
  mattr_accessor :capturable_client_secret
  mattr_accessor :capturable_redirect_uri
  mattr_accessor :capturable_auto_create_account
  mattr_accessor :capturable_redirect_if_no_user
end

Devise.capturable_auto_create_account = true

I18n.load_path.unshift File.join(File.dirname(__FILE__), *%w[devise_capturable locales en.yml])
Devise.add_module(:capturable, :strategy => true, :controller => :sessions, :model => 'devise_capturable/model', :route => { :capturable => [nil, :reset_password, :federate_logout]})

module Devise
  module Capturable
    module Rails
      class Engine < ::Rails::Engine
      end
    end
  end
end
