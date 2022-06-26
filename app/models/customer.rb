class Customer < ApplicationRecord
  has_many :appoint

  validates :first_name, :last_name, :first_name_kana, :last_name_kana, presence: true
  validates :email, presence: true
  validates :password, presence: true, length: { in: 6..20 }
  
end
