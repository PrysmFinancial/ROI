class Shift < ApplicationRecord
  has_many :server_shifts, dependent: :destroy
  has_many :servers, through: :server_shifts
  has_many :sections, -> { order(:position) }, dependent: :destroy
  has_many :parties, dependent: :destroy
  has_many :pacing_recommendations, dependent: :destroy
  has_many :cut_recommendations, dependent: :destroy

  validates :service_date, :location_name, presence: true

  def self.current
    order(service_date: :desc, id: :desc).first
  end

  def pacing_hold_active?
    pacing_hold_until.present? && pacing_hold_until.future?
  end

  def open_pacing_recommendation
    pacing_recommendations.where(status: "open").order(created_at: :desc).first
  end

  def open_cut_recommendation
    cut_recommendations.where(status: %w[open flagged]).order(created_at: :desc).first
  end

  def confirmation_counts
    scoped = parties.where(source: "reservation").where.not(reservation_time: nil)
    {
      confirmed: scoped.where(confirmation_status: "confirmed").count,
      pending: scoped.where(confirmation_status: %w[pending no_answer]).count
    }
  end
end
