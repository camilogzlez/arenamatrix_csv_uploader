class Spectacle < ApplicationRecord
  has_many :representations
  has_many :reservations
end
