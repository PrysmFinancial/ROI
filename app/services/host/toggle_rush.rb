module Host
  class ToggleRush
    def self.call(shift:, enabled:)
      new(shift, enabled).call
    end

    def initialize(shift, enabled)
      @shift = shift
      @enabled = ActiveModel::Type::Boolean.new.cast(enabled)
    end

    def call
      attrs = { rush_mode: enabled }
      # Floor-wide rush suspends pacing holds for the whole floor.
      attrs[:pacing_hold_until] = nil if enabled

      shift.update!(attrs)
      shift
    end

    private

    attr_reader :shift, :enabled
  end
end
