require "spec_helper"
require "active_support/all"
require File.join(File.dirname(__FILE__), '..', 'lib', 'devise_capturable', 'strategy')

class User
end

PARAMS = { :code => "abcdefghijklmn" }
TOKEN = {"access_token" => "abcdefg", "stat" => "ok"}
REFRESH_TOKEN = {"access_token" => "hijklmn", "stat" => "ok"}
ENTITY = {"result" => { "uuid" => "1234", "email" => "some@email.com" }}

describe 'Devise::Capturable' do
  
  before(:each) do
    @strategy = Devise::Capturable::Strategies::Capturable.new
    @mapping = double(:mapping)
    @user = User.new
    expect(@mapping).to receive(:to).and_return(User)
    expect(@strategy).to receive(:mapping).and_return(@mapping)
    expect(@strategy).to receive(:params).at_least(:once).and_return(PARAMS)
    allow(Devise::Capturable::API).to receive(:token).and_return(TOKEN)
    allow(Devise::Capturable::API).to receive(:refresh_token).and_return(REFRESH_TOKEN)
    allow(Devise::Capturable::API).to receive(:entity).and_return(ENTITY)
  end

  describe "if user exists" do
  
    it "should sign in" do
      expect(User).to receive(:find_with_capturable_params).with(ENTITY["result"]).and_return(@user)
      expect(@user).to receive(:before_capturable_sign_in).with(ENTITY["result"], PARAMS)
      expect(@user).to_not receive(:save!)
      expect(@strategy).to receive(:success!).with(@user)
      @strategy.authenticate!
    end

  end
    
  describe "if user does not exist" do
    
    before(:each) do
      expect(User).to receive(:find_with_capturable_params).and_return(nil)
    end

    describe "and capturable_auto_create_account is enabled" do

      before(:each) do
        Devise.stub(:capturable_auto_create_account).and_return(true)
        expect(User).to receive(:new).and_return(@user)
        expect(@user).to receive(:before_capturable_create).with(ENTITY["result"], PARAMS)
      end

      it "should fail if not saved" do
        expect(@user).to receive(:save).and_return(false)
        expect(@strategy).to_not receive(:success!)
        expect(@strategy).to receive(:fail!).with(:capturable_user_error)
        @strategy.authenticate!
      end
      
      it "should succeed if saved" do
        expect(@user).to receive(:save).and_return(true)
        expect(@strategy).to receive(:success!).with(@user)
        expect(@strategy).to_not receive(:fail!)
        @strategy.authenticate!
      end

    end

    describe "and capturable_redirect_if_no_user is enabled" do

      before(:each) do
        Devise.stub(:capturable_auto_create_account).and_return(false)
        Devise.stub(:capturable_redirect_if_no_user).and_return("/users/sign_up")
      end

      it "should redirect" do
        expect(@user).to_not receive(:save!)
        expect(@strategy).to_not receive(:success!)
        expect(@strategy).to receive(:fail!).with(:capturable_user_missing)
        expect(@strategy).to receive(:redirect!).with("/users/sign_up?token=hijklmn")
        @strategy.authenticate!
      end

    end

    describe "and nothing is enabled" do

      before(:each) do
        Devise.stub(:capturable_auto_create_account).and_return(false)
        Devise.stub(:capturable_redirect_if_no_user).and_return(false)
      end

      it "should not call user save" do
        expect(@user).to_not receive(:save!)
        expect(@strategy).to_not receive(:success!)
        expect(@strategy).to receive(:fail!).with(:capturable_user_missing)
        @strategy.authenticate!
      end

    end
              
  end

end