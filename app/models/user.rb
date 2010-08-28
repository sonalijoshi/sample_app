# == Schema Information
# Schema version: 20100822155813
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  validates :name, :presence => true
  validates :name, :length => {:maximum => 50 }
  validates :email, :presence => true,
                    :uniqueness => {:case_sensitive => false}
  validates :password, :confirmation => true,
                       :length => {:within => (6..40)},
                       :presence => true

  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(submitted_email, submitted_password)
    user = find_by_email(submitted_email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

   private

  def encrypt_password()
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def make_salt
     secure_hash("#{Time.now.utc}-#{password}")
  end

  def encrypt(submitted_password)
    secure_hash("#{salt}--#{submitted_password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
