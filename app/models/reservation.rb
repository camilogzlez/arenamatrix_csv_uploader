class Reservation < ApplicationRecord
  belongs_to :representation
  belongs_to :spectacle
  belongs_to :client

  scope :by_spectacle, ->(spectacle_id) { where(spectacle_id: spectacle_id) }
  scope :by_representation, ->(representation_id) { where(representation_id: representation_id) }
end
