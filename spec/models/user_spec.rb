require 'spec_helper'

describe User do
  before(:each) do
    @attr = {:name => "someone",
             :email => "bc@abc.com",
             :password => "foobar",
             :password_confirmation => "foobar"
            }
  end

  it "should create a new instance given valid attributes" do
      User.create!(@attr)
  end

  it "should validate that name is not empty" do
    user = User.new(@attr.merge(:name => ""))
    user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    upcased_email = @attr[:email].upcase
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr.merge(:email => upcased_email))
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do
    it "should validate that password has maximum of 40 characters" do
      user = User.create(@attr.merge(:password => "a" * 41))
      user.should_not be_valid
    end

    it "should validate that password_confirmation has maximum of 40 characters" do
      user = User.create(@attr.merge(:password_confirmation => "a" * 41))
      user.should_not be_valid
    end

    it "should validate that password has minimum of 6 characters" do
      user = User.create(@attr.merge(:password => "a" * 5))
      user.should_not be_valid
    end

    it "should validate that password_confirmation has minimum of 6 characters" do
      user = User.create(@attr.merge(:password_confirmation => "a" * 5))
      user.should_not be_valid
    end

    it "should require a password and confirmation" do
      user = User.create(@attr.merge(:password => "", :password_confirmation => ""))
      user.should_not be_valid        
    end

    it "should require a matching password confirmation" do
      user = User.create(@attr.merge(:password_confirmation => "doesnotmatchpassword"))
      user.should_not be_valid
    end
  end


  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
         @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end

   end

    describe "user authentication" do
      it "should return nil if submitted password/email do not match" do
        user = User.authenticate(@attr[:email], "wrongpassword")
        user.should be_nil
      end

      it "should return nil if user does not exist with email" do
           non_existent_user = User.authenticate("wrong email", @attr[:password])
           non_existent_user.should be_nil
      end

      it "should return user on email/password match" do
          User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end

  end
end
