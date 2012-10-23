require 'spec_helper_integration'

describe Doorkeeper, "configuration" do
  subject { Doorkeeper.configuration }

  describe "resource_owner_authenticator" do
    it "sets the block that is accessible via authenticate_resource_owner" do
      block = proc do end
      Doorkeeper.configure do
        resource_owner_authenticator &block
      end
      subject.authenticate_resource_owner.should == block
    end
  end

  describe "admin_authenticator" do
    it "sets the block that is accessible via authenticate_admin" do
      block = proc do end
      Doorkeeper.configure do
        admin_authenticator &block
      end
      subject.authenticate_admin.should == block
    end
  end

  describe "access_token_expires_in" do
    it "has 2 hours by default" do
      subject.access_token_expires_in.should == 2.hours
    end

    it "can change the value" do
      Doorkeeper.configure do
        access_token_expires_in 4.hours
      end
      subject.access_token_expires_in.should == 4.hours
    end

    it "can be set to nil" do
      Doorkeeper.configure do
        access_token_expires_in nil
      end
      subject.access_token_expires_in.should be_nil
    end
  end

  describe "scopes" do
    it "has default scopes" do
      Doorkeeper.configure { default_scopes :public }
      subject.default_scopes.should include(:public)
    end

    it 'has optional scopes' do
      Doorkeeper.configure { optional_scopes :write, :update }
      subject.optional_scopes.should include(:write, :update)
    end

    it 'has all scopes' do
      Doorkeeper.configure do
        default_scopes  :normal
        optional_scopes :admin
      end
      subject.scopes.should include(:normal, :admin)
    end
  end

  describe "use_refresh_token" do
    it "is false by default" do
      subject.refresh_token_enabled?.should be_false
    end

    it "can change the value" do
      Doorkeeper.configure { use_refresh_token }
      subject.refresh_token_enabled?.should be_true
    end
  end

  describe 'client_credentials' do
    it 'has defaults order' do
      subject.client_credentials_methods.should == [:from_basic, :from_params]
    end

    it "can change the value" do
      Doorkeeper.configure { client_credentials :from_digest, :from_params }
      subject.client_credentials_methods.should == [:from_digest, :from_params]
    end
  end
end
