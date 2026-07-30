class SeatingRecommendation < ApplicationRecord
  STATUSES = %w[open accepted declined overridden].freeze

  belongs_to :party
  belongs_to :dining_table
  belongs_to :server_shift

  validates :summary, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :open, -> { where(status: "open") }

  def summary_label
    summary
  end
end
