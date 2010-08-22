require 'spec_helper'

describe User do
  before(:each) do
    @attr = {:name => "someone", :email => "bc@abc.com"}
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
  
end
