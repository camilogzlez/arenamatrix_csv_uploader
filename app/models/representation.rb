class Representation < ApplicationRecord
  belongs_to :spectacle
  has_many :reservations
end
