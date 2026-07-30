class PacingRecommendation < ApplicationRecord
  STATUSES = %w[open confirmed declined].freeze

  belongs_to :shift

  validates :message, :hold_minutes, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :open, -> { where(status: "open") }
end
