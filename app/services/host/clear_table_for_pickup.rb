module Host
  class ClearTableForPickup
    class NotSeatedError < StandardError; end
    class NotCutSectionError < StandardError; end
    class NoPickupServerError < StandardError; end

    def self.call(dining_table:)
      new(dining_table).call
    end

    def initialize(dining_table)
      @dining_table = dining_table
      @section = dining_table.section
      @shift = section.shift
      @cut_server = section.server_shift
    end

    def call
      raise NotSeatedError, "Table is not seated" unless dining_table.status == "seated"
      raise NotCutSectionError, "Section server is not cut" unless cut_server&.cut_status == "approved"

      pickup = nearest_active_server
      raise NoPickupServerError, "No active server available for pickup" unless pickup

      party = dining_table.active_party

      ActiveRecord::Base.transaction do
        if party
          party.update!(lifecycle: "done")
        end
        dining_table.update!(status: "open", seated_at: nil)
        section.update!(pickup_server_shift: pickup)

        Host::LogDecision.call(
          shift:,
          kind: "pickup_assigned",
          party:,
          summary: "#{dining_table.label} cleared → pickup #{pickup.name}",
          detail: "Mock clear from cut server #{cut_server.name}; nearest by section position then covers."
        )
      end

      { dining_table:, pickup: }
    end

    private

    attr_reader :dining_table, :section, :shift, :cut_server

    # Nearest without floor geometry: closest section position, then fewest covers, then start order.
    def nearest_active_server
      candidates = shift.server_shifts.active.includes(:server, :section).reject { |ss| ss.id == cut_server.id }
      return nil if candidates.empty?

      candidates.min_by do |ss|
        other_pos = ss.section&.position || 99
        [
          (other_pos - section.position).abs,
          ss.covers_tonight,
          ss.start_order,
          ss.id
        ]
      end
    end
  end
end
