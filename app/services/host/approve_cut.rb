module Host
  class ApproveCut
    class InvalidPinError < StandardError; end

    def self.call(recommendation:, pin:)
      new(recommendation, pin).call
    end

    def initialize(recommendation, pin)
      @recommendation = recommendation
      @pin = pin.to_s
      @shift = recommendation.shift
      @server_shift = recommendation.server_shift
    end

    def call
      raise InvalidPinError, "Invalid manager code" unless pin == shift.manager_pin

      ActiveRecord::Base.transaction do
        recommendation.update!(status: "approved", approved_at: Time.current)
        server_shift.update!(cut_status: "approved")
      end

      recommendation
    end

    private

    attr_reader :recommendation, :pin, :shift, :server_shift
  end
end
