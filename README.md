# Devise::Capturable

`Devise::Capturable` is a gem that makes it possible to use the Janrain Engage user registration widget as a login system, while still having a Devise authentication setup with a Rails `User` model.

It can be used right out of the box with automatic user creation, or can be configured to show a "second step form", to add extra values to your user model on top of Janrain.

In the following I use the name `User` for the Devise user model, but it will work with any Devise-enabled model.

## Flow

This gem will replace the normal Devise `registrations` and `sessions` views with the Janrain user registration widget. The flow is as follows.

* User clicks a login link
* User is presented with the user registration widget and either registers or logs in
* The gem automatically listens to the widget's `onCaptureLoginSuccess` event, grabs the oauth code, and makes a `POST` request with the OAuth code to the `sessions_controller`
* The gem will grab the oauth token in the `session_controller`, load the user data from the Capture API (to ensure the validity of the token), and either create a new user or log in the user if the user already exists in the Rails DB.

## Setup

You will need to perform these steps to setup the gem.

#### Add gem to Gemfile

Inside your Gemfile, after including Devise:

```ruby
gem 'devise_capturable', :github => 'oreillymedia/devise-capturable', :branch => 'extract-functionality-from-test-app'
```

#### Set up your ENV

We strongly recommend using [dotenv-rails](http://rubygems.org/gems/dotenv-rails) or a similar utility to load Janrain environment-specific configuration data. Include the following values:

* JANRAIN_WIDGET_LOAD_PATH: The full URL for your app's signin widget, hosted by Janrain; for example, "d16s8pqtk4uodx.cloudfront.net/oreilly-dev/load.js"
* JANRAIN_APP_URL: The application URL for your Capture/Engage installation, hosted by Janrain; for example, https://oreilly-dev.rpxnow.com
* JANRAIN_APP_ID: The application ID for your Capture installation, found in the Janrain Dashboard.
* JANRAIN_ENDPOINT_URL: Your application's server for accessing the Janrain API; for example, https://oreilly.dev.janraincapture.com/
* JANRAIN_CLIENT_ID: Your API client's ID, found in the Janrain Dashboard.
* JANRAIN_CLIENT_SECRET: Your API client's secret, found in the Janrain Dashboard.
* JANRAIN_FEDERATE_SERVER: The host for your application's Federate server; for example, https://oreilly-dev.janrainsso.com
* JANRAIN_REDIRECT_URI: Your application's specific value to verify client-side and server-side interactions with Janrain. Almost certainly your application's host and protocol; for example, http://localhost or https://myapp.oreilly.com

#### Add `:capturable` to your `User` model

Add capturable to your the list of Devise extensions:

```ruby
class User < ActiveRecord::Base
  devise :capturable, # other extensions ...
  # etc.
end
```

Note: At this time, the database_authenticatable extension is required in order for sign-in and sign-up route helpers to work.

#### Setup the route

Override the default Devise sessions routes in your application's `routes.rb`:

```ruby
devise_for :users, :controllers => { :sessions => 'sessions' }
```

#### Update initializer

Inside `devise.rb`:

```ruby
Devise.setup do |config|
  # other configs ...
  config.capturable_server = ENV['JANRAIN_ENDPOINT_URL']
  config.capturable_client_id = ENV['JANRAIN_CLIENT_ID']
  config.capturable_client_secret = ENV['JANRAIN_CLIENT_SECRET']
  config.capturable_redirect_uri = ENV['JANRAIN_REDIRECT_URI']
  config.capturable_auto_create_account = true # optional; see below
  config.capturable_redirect_if_no_user = "/users/sign_up" # optional; see below
  # other configs ...
end
```

#### Inline Janrain JavaScript configuration

These settings must be provided on all pages in order for Janrain logout to work. You can either inline them in a layout, or create a partial.

```html
<script type="text/javascript">
window.widget_load_path = '<%= ENV['JANRAIN_WIDGET_LOAD_PATH'] %>';
jQuery(document).ready(function() {
  if(window.janrain) {
    window.janrain.settings['appUrl'] = '<%= ENV['JANRAIN_APP_URL'] %>';
    window.janrain.settings.capture['appId'] = '<%= ENV['JANRAIN_APP_ID'] %>';
    window.janrain.settings.capture['captureServer'] = '<%= ENV['JANRAIN_ENDPOINT_URL'] %>';
    window.janrain.settings.capture['clientId'] = '<%= ENV['JANRAIN_CLIENT_ID'] %>';
    window.janrain.settings.capture['federateServer'] = '<%= ENV['JANRAIN_FEDERATE_SERVER'] %>';
    window.janrain.settings.capture['federateXdReceiver'] = '<%= user_federate_xd_receiver_url %>';
    window.janrain.settings.capture['federateLogoutUri'] = '<%= user_federate_logout_url %>';
    window.janrain.settings.capture['redirectUri'] = '<%= ENV['JANRAIN_REDIRECT_URI'] %>';
    window.janrain.settings.capture['stylesheets'] = ['//cdn.oreillystatic.com/members/css/janrain.min.css'];
    window.janrain.settings.capture['mobileStylesheets'] = ['//cdn.oreillystatic.com/members/css/janrain-mobile.min.css'];
  }
});
</script>
```

If your Devise model is named something besides User, update the values for `user_federate_xd_receiver_url` and `user_federate_logout_url` accordingly. (e.g., `admin_federate_logout_url`). If you're not sure, check your available routes via `rake routes`.

#### Add logout partial

Devise::Capturable includes a logout partial containing just enough JavaScript to handle Janrain/Federate logout and an HTML link to initiate it. To include it, just render the partial:

```erb
<%= render 'capturable/logout' %>
```

#### Add Capturable to your asset pipeline

```javascript
//= require devise_capturable
```

#### Add Janrain CSS

Now add the Janrain CSS to your asset pipeline. Simply copy `janrain.css` and `janrain-mobile.css` to `app/assets/stylesheets`.

#### Add links

The gem ships with a helper method to show a link that opens the widget. You will use this to show the login / registration form, but use the normal `destroy_user_session_path` helper to log out the user. This is because Devise, not Capture, is controlling the user cookie.

```erb
<ul class="nav">
  <% if user_signed_in? %>
    <li><%= link_to 'Logout', destroy_user_session_path, :method=>'delete' %></li>
  <% else %>
    <li><%= link_to_capturable "Sign In / Sign Up" %></li>
  <% end %>
</ul>
```

#### Done!

That's it! 

By default Devise will now create a database record when the user logs in for the first time. On following logins, the user will just be logged in. The only property Devise will save in the user model is the `email` address provided by Capture. You can however change this (See "Changing Defaults")

## Automated Settings

The Janrain User Registration widget relies on settings that are 1) never used and 2) breaks the widget if they are not present. To circumvent this madness, this gem will automatically set a bunch of janrain setting variables for you:

```javascript
// default settings for gem
janrain.settings.capture.flowName = 'signIn';
janrain.settings.capture.responseType = 'code';
janrain.settings.capture.redirectUri = 'http://stupidsettings.com';
```

You can delete these settings from your embed code, as the gem will set them for you. Remember that you still need a `tokenUrl` setting with a whitelisted URL, even though this setting is never used either.

## Changing defaults

#### Overriding `before_capturable_create`

There are times where you might want to save more than the `email` of your user in the Rails `User` model. You can override the `before_capturable_create` instance method to do this. Here's an example where I'm also saving the `uuid`. The `capture_data` parameter passed to the function is the Janrain Capture `entity` JSON result that has a bunch of information about the user, and the `params` parameter is the controller parameters.

```ruby
class User < ActiveRecord::Base
  devise ..., :capturable
  def before_capturable_create(capture_data, params)
  	self.email = capture_data["email"]
  	self.uuid = capture_data["uuid"]
  end
end
```

#### Overriding `before_capturable_sign_in`

You might also want to update your Rails model if the data changes on the Janrain side. You can use the `before_capturable_sign_in` method for this. This method is empty by default, but can be defined in your model to update certain attributes. Here's an example where we update the fake "is_awesome" attribute.

```ruby
class User < ActiveRecord::Base
  devise ..., :capturable
  def before_capturable_sign_in(capture_data, params)
    self.is_awesome = capture_data["is_awesome"]
    self.save!
  end
end
```

#### Overriding `find_with_capturable_params`

When a user logs in, Devise will call the Capture API and try to find a user with the email returned by the API. You can change this by overriding the `find_with_capturable_params` instance method in your `User` model. Here's an example where I'm telling Devise to find the user by the `uuid` instead.

```ruby
def find_with_capturable_params(capture_data)
	self.find_by_uuid(capture_data["uuid"])
end
```

#### Disabling User Creation

By default the gem will create a user if the user doesn't exist in the system. If you want to disable the creation of new users, and only allow current users to log in, you can disable automatic account creation in your `config/intitializers/devise.rb` initializer.

```ruby
Devise.setup do |config|
	config.capturable_auto_create_account = false
end
```

#### Overriding `janrainCaptureWidgetOnLoad`

There are a number of reasons you may need to override the default `janrainCaptureWidgetOnLoad` Javascript function:

* To use the `signInEmbedded` flow instead of the default `signIn`
* To specify a `redirectUri` value (required to use Janrain's Federate feature)
* To add functionality to Janrain event handlers, or add more event handlers

To do so, you'll need to write your own `janrainCaptureWidgetOnLoad` function and include it separately. In this example, I'm replacing the default function with my own, included inline when loading the Janrain widget:

```javascript
  function janrainCaptureWidgetOnLoad() {
    janrain.settings.capture.flowName = 'signInEmbedded';
    janrain.settings.capture.responseType = 'code';
    janrain.settings.capture.redirectUri = 'http://mydomain.com';
    janrain.capture.ui.start();

    // afterJanrainLogin is provided by Devise::Capturable to assist with
    // server-side login. It automatically makes a POST request to /users/sign_in if not configured.
    janrain.events.onCaptureLoginSuccess.addHandler(afterJanrainLogin);
    janrain.events.onCaptureRegistrationSuccess.addHandler(afterJanrainLogin);
  };
```

Finally, I can also provide an optional path to send the Janrain `authorizationCode` to in my application, if using a Devise resource not named `User`:

```erb
janrain.events.onCaptureRegistrationSuccess.addHandler(function(result) {
  afterJanrainLogin(result, '<%= new_admin_session_path %>', "get");
});
```

## Running the Tests

* Install development and test dependencies with `bundle install`
* Setup a test database: `cd spec/rails_app && rake db:migrate db:test:prepare`
* From the project root, run the tests with the `rspec` command.

## TODO

* Update server-side login to handle the "modal" Janrain login widget.
* Remove normal Devise sign_in routes? Or leave it up to the user?
