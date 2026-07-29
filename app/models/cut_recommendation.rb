class CutRecommendation < ApplicationRecord
  STATUSES = %w[open flagged approved declined].freeze

  belongs_to :shift
  belongs_to :server_shift

  validates :reason, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :actionable, -> { where(status: %w[open flagged]) }
end
