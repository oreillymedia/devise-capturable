require 'devise_capturable/api'

module Devise
  
  module Capturable
    
    module Strategies

      class Capturable < ::Devise::Strategies::Base

        def valid?
          valid_controller? && valid_params? && mapping.to.respond_to?(:find_with_capturable_params) && mapping.to.method_defined?(:set_capturable_params)
        end

        def authenticate!
          klass = mapping.to
      
          begin
  
            token = CaptureAPI.token(params[:code])
            fail!(:capturable_invalid) unless token['stat'] == 'ok'
              
            entity = CaptureAPI.entity(token['access_token'])
            user = klass.find_with_capturable_params(entity["result"]) 

            if user
              success!(user)
              return
            end

            unless klass.capturable_auto_create_account?
              fail!(:capturable_invalid)
              return
            end
            
            user = klass.new
            user.set_capturable_params(entity["result"])            
            user.save(:validate => false)
            success!(user)
          rescue Exception => e
            puts e.inspect
            fail!(:capturable_invalid)
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

