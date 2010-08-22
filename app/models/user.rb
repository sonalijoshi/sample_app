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
  attr_accessible :name, :email

  validates :name, :presence => true
  validates :name, :length => {:maximum => 50 }
  validates :email, :presence => true,
                    :uniqueness => {:case_sensitive => false}
end
