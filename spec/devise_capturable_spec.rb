require "spec_helper"
require "active_support/all"
require File.join(File.dirname(__FILE__), '..', 'lib', 'devise_capturable', 'strategy')

class User
end

PARAMS = { :userData => { :uuid => "0112723a-f9c7-41b5-98ab-8b7c160795f1" }}

describe 'Devise::Capturable' do
  
  before(:each) do
    @strategy = Devise::Capturable::Strategies::Capturable.new
    @mapping = mock(:mapping)
    @mapping.should_receive(:to).and_return(User)
    @strategy.should_receive(:mapping).and_return(@mapping)
    @strategy.should_receive(:params).at_least(1).and_return(PARAMS)
    @user = User.new
  end
  
  it "should authenticate if a user exists in database" do        
    User.should_receive(:find_with_capturable_params).with(PARAMS).and_return(@user)
    @strategy.should_receive(:"success!").with(@user).and_return(true)
    lambda { @strategy.authenticate! }.should_not raise_error
  end
    
  describe 'when no user exists in database' do
    
    before(:each) do
      User.should_receive(:find_with_capturable_params).with(PARAMS).and_return(nil)
    end
              
    it "should fail unless capturable_auto_create_account" do
      User.should_receive(:"capturable_auto_create_account?").and_return(false)
      @strategy.should_receive(:"fail!").with(:capturable_invalid).and_return(true)
      lambda { @strategy.authenticate! }.should_not raise_error
    end
    
    it "should create a new user and success if capturable_auto_create_account" do
      User.should_receive(:"capturable_auto_create_account?").and_return(true)
      User.should_receive(:new).and_return(@user)
      @user.should_receive(:"set_capturable_params").with(PARAMS).and_return(true)
      @user.should_receive(:save).with({ :validate => false }).and_return(true)
      @strategy.should_receive(:"success!").with(@user).and_return(true)
      lambda { @strategy.authenticate! }.should_not raise_error
    end
  end

end

