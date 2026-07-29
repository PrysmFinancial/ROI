class Server < ApplicationRecord
  has_many :server_shifts, dependent: :destroy

  validates :name, :initial, presence: true
end
