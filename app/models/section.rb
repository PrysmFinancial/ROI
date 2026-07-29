class Section < ApplicationRecord
  belongs_to :shift
  belongs_to :server_shift, optional: true
  has_many :dining_tables, -> { order(:label) }, dependent: :destroy

  validates :name, presence: true

  def table_summary
    labels = dining_tables.map(&:label)
    return "#{name} · 0 tables" if labels.empty?

    "#{labels.first}–#{labels.last} · #{dining_tables.size} #{dining_tables.first.seat_noun}"
  end
end
