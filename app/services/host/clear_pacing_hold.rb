module Host
  class ClearPacingHold
    def self.call(shift:)
      new(shift).call
    end

    def initialize(shift)
      @shift = shift
    end

    def call
      shift.update!(pacing_hold_until: nil)
      shift
    end

    private

    attr_reader :shift
  end
end
