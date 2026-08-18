class DecisionEvent < ApplicationRecord
  KINDS = %w[
    seating_accepted
    seating_overridden
    pacing_confirmed
    pacing_declined
    cut_approved
    pickup_assigned
    pass_note
  ].freeze

  belongs_to :shift
  belongs_to :party, optional: true

  validates :kind, inclusion: { in: KINDS }
  validates :summary, presence: true

  scope :for_shift, ->(shift) { where(shift:).order(created_at: :desc, id: :desc) }

  def kind_label
    kind.tr("_", " ").titleize
  end
end
