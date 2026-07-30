class Manager < ApplicationRecord
  has_many :approved_cuts, class_name: "CutRecommendation", foreign_key: :approved_by_manager_id, inverse_of: :approved_by_manager, dependent: :nullify

  validates :name, :pin, presence: true
  validates :pin, uniqueness: true, format: { with: /\A\d{4}\z/, message: "must be 4 digits" }

  scope :active, -> { where(active: true) }

  def self.authenticate_pin(pin)
    active.find_by(pin: pin.to_s)
  end
end
