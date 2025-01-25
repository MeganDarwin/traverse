class User < ApplicationRecord
  has_many :travels, dependent: :destroy

  # to do add validations
  # name: not null (make sure db matches)
  # start date/end date

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
