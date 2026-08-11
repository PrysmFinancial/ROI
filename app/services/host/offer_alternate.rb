module Host
  class OfferAlternate
    class HoldActiveError < StandardError; end
    class MissingRecommendationError < StandardError; end
    class InvalidAlternateError < StandardError; end
    class ReasonRequiredError < StandardError; end

    def self.call(party:, dining_table:, server_shift:, reason:)
      new(party, dining_table, server_shift, reason).call
    end

    def initialize(party, dining_table, server_shift, reason)
      @party = party
      @dining_table = dining_table
      @server_shift = server_shift
      @reason = reason.to_s.strip
      @shift = party.shift
    end

    def call
      raise HoldActiveError, "Pacing hold is active" if shift.pacing_hold_active?
      raise ReasonRequiredError, "Override reason is required" if reason.blank?

      recommendation = party.seating_recommendation
      raise MissingRecommendationError, "No open recommendation" unless recommendation&.status == "open"

      raise InvalidAlternateError, "That table/server pairing is not a legal alternate" unless legal_alternate?

      ActiveRecord::Base.transaction do
        dining_table.update!(status: "seated", seated_at: Time.current)
        party.update!(
          lifecycle: "seated",
          dining_table: dining_table,
          server_shift: server_shift,
          queue_position: nil,
          rush_tagged: shift.rush_mode?
        )
        recommendation.update!(
          dining_table: dining_table,
          server_shift: server_shift,
          summary: "Host override · #{dining_table.label} · #{server_shift.name}",
          status: "overridden",
          override_reason: reason
        )
        server_shift.increment!(:covers_tonight, party.covers)
        Host::LogDecision.call(
          shift:,
          party:,
          kind: "seating_overridden",
          summary: "Override #{party.name} → #{dining_table.label} · #{server_shift.name}",
          detail: reason
        )
      end

      party
    end

    private

    attr_reader :party, :dining_table, :server_shift, :reason, :shift

    def legal_alternate?
      Seating::AssignmentEngine.alternatives(party: party).any? do |option|
        option[:dining_table].id == dining_table.id &&
          option[:server_shift].id == server_shift.id
      end
    end
  end
end
