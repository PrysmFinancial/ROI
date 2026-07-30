class Party < ApplicationRecord
  CONFIRMATION_STATUSES = %w[pending confirmed no_answer cancelled].freeze
  LIFECYCLES = %w[booked waiting seated held done].freeze
  SOURCES = %w[reservation walk_in].freeze

  belongs_to :shift
  belongs_to :dining_table, optional: true
  belongs_to :server_shift, optional: true
  has_one :seating_recommendation, dependent: :destroy

  validates :name, :covers, presence: true
  validates :confirmation_status, inclusion: { in: CONFIRMATION_STATUSES }
  validates :lifecycle, inclusion: { in: LIFECYCLES }
  validates :source, inclusion: { in: SOURCES }

  scope :for_confirmation_calls, -> {
    where(source: "reservation").where.not(reservation_time: nil).order(:reservation_time, :id)
  }
  scope :in_queue, -> { where(lifecycle: "waiting").order(:queue_position, :id) }
  scope :for_book, -> { where(lifecycle: %w[booked waiting]).order(:reservation_time, :id) }

  def pending_confirmation?
    confirmation_status.in?(%w[pending no_answer])
  end

  def reservation_time_label
    reservation_time&.strftime("%-l:%M")
  end

  def meta_label
    if source == "walk_in"
      parts = [ "Walk-in" ]
      parts << "quoted #{quoted_wait_minutes} min" if quoted_wait_minutes
      parts << "#{covers} covers"
      parts.join(" · ")
    else
      "#{reservation_time_label} reservation · #{covers} covers"
    end
  end
end
