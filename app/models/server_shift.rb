class ServerShift < ApplicationRecord
  CUT_STATUSES = %w[none flagged approved].freeze

  belongs_to :shift
  belongs_to :server
  has_one :section, dependent: :nullify
  has_many :parties, dependent: :nullify

  validates :start_order, presence: true
  validates :cut_status, inclusion: { in: CUT_STATUSES }

  scope :active, -> { where.not(cut_status: "approved") }
  scope :cut_protected, -> { where(cut_status: %w[flagged approved]) }

  delegate :name, :initial, to: :server

  def cut?
    cut_status.in?(%w[flagged approved])
  end

  def display_name
    name
  end
end
