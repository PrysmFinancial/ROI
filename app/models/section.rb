class Section < ApplicationRecord
  belongs_to :shift
  belongs_to :server_shift, optional: true
  belongs_to :pickup_server_shift, class_name: "ServerShift", optional: true
  has_many :dining_tables, -> { order(:label) }, dependent: :destroy

  validates :name, presence: true

  def table_summary
    labels = dining_tables.map(&:label)
    return "#{name} · 0 tables" if labels.empty?

    base = "#{labels.first}–#{labels.last} · #{dining_tables.size} #{dining_tables.first.seat_noun}"
    return base unless pickup_server_shift

    "#{base} · pickup #{pickup_server_shift.name}"
  end
end
