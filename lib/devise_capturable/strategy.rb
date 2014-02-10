require 'devise_capturable/api'

module Devise
  
  module Capturable
    
    module Strategies

      class Capturable < ::Devise::Strategies::Base

        def valid?
          valid_controller? && valid_params? && mapping.to.respond_to?(:find_with_capturable_params) && mapping.to.method_defined?(:before_capturable_create) && mapping.to.method_defined?(:before_capturable_sign_in)
        end

        def authenticate!
          
          klass = mapping.to

          begin

            # get an access token from an OAUTH code
            token = Devise::Capturable::API.token(params[:code])
            fail!(:capturable_invalid) unless token['stat'] == 'ok'

            # get the user info form the access token
            entity = Devise::Capturable::API.entity(token['access_token'])
            
            # find user with the capturable params
            user = klass.find_with_capturable_params(entity["result"])

            # if the user exists, sign in
            if user
              user.before_capturable_sign_in(entity["result"], params)
              success!(user)
            # else if we want to auto create users
            elsif Devise.capturable_auto_create_account
              user = klass.new
              user.before_capturable_create(entity["result"], params)
              user.save!
              success!(user)
            # else fail
            elsif Devise.capturable_redirect_if_no_user
              fail!(:capturable_user_missing)
              redirect!(Devise.capturable_redirect_if_no_user)
            else
              fail!(:capturable_user_missing)
            end
          rescue Exception => e
            puts "Devise Capturable Error: #{e}"
            fail!(:capturable_user_error)
          end
        end
        
        protected
          
        def valid_controller?
          params[:controller].to_s =~ /sessions/
        end

        def valid_params?
          params[:code].present?
        end

      end
    end
  end
end

