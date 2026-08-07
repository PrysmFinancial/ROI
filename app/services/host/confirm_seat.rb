module Host
  class ConfirmSeat
    class HoldActiveError < StandardError; end
    class MissingRecommendationError < StandardError; end

    def self.call(party:)
      new(party).call
    end

    def initialize(party)
      @party = party
      @shift = party.shift
    end

    def call
      raise HoldActiveError, "Pacing hold is active" if shift.pacing_hold_active?

      recommendation = party.seating_recommendation
      raise MissingRecommendationError, "No open recommendation" unless recommendation&.status == "open"

      table = recommendation.dining_table
      server_shift = recommendation.server_shift

      ActiveRecord::Base.transaction do
        table.update!(status: "seated", seated_at: Time.current)
        party.update!(
          lifecycle: "seated",
          dining_table: table,
          server_shift: server_shift,
          queue_position: nil,
          rush_tagged: shift.rush_mode?
        )
        recommendation.update!(status: "accepted")
        server_shift.increment!(:covers_tonight, party.covers)
      end

      party
    end

    private

    attr_reader :party, :shift
  end
end
