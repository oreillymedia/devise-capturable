module ActionDispatch::Routing

  class Mapper

    protected

    def devise_capturable(mapping, controllers)
      get 'federate_logout' => 'sessions#destroy'
      get 'reset_password' => 'passwords#edit'
      get 'federate_xd_receiver' => 'federate#xd_receiver'
    end
  end
end
