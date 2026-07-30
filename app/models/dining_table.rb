class DiningTable < ApplicationRecord
  STATUSES = %w[open seated held].freeze

  belongs_to :section
  has_one :shift, through: :section
  has_many :parties, dependent: :nullify

  validates :label, :capacity, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :open_for_seating, -> { where(status: "open") }

  def seat_noun
    label.start_with?("B") ? "seats" : "tables"
  end

  def capacity_label
    label.start_with?("B") ? "#{capacity} seats" : "#{capacity} top"
  end

  def seated_duration_label
    return nil unless seated_at

    minutes = ((Time.current - seated_at) / 60).floor
    "#{minutes}m"
  end

  def active_party
    parties.find_by(lifecycle: %w[seated held]) || parties.order(updated_at: :desc).first
  end

  def guest_label
    party = active_party
    return "Open" if status == "open"
    return "Held · #{party.covers}" if status == "held" && party
    return party.name if party

    "—"
  end
end
