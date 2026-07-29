module Host
  class ApproveSections
    def self.call(shift:)
      new(shift).call
    end

    def initialize(shift)
      @shift = shift
    end

    def call
      shift.update!(sections_approved: true, sections_approved_at: Time.current)
      shift
    end

    private

    attr_reader :shift
  end
end
