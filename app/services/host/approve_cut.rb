module Host
  class ApproveCut
    class InvalidPinError < StandardError; end

    def self.call(recommendation:, pin:)
      new(recommendation, pin).call
    end

    def initialize(recommendation, pin)
      @recommendation = recommendation
      @pin = pin.to_s
      @server_shift = recommendation.server_shift
    end

    def call
      manager = Manager.authenticate_pin(pin)
      raise InvalidPinError, "Invalid manager code" unless manager

      ActiveRecord::Base.transaction do
        recommendation.update!(
          status: "approved",
          approved_at: Time.current,
          approved_by_manager: manager
        )
        server_shift.update!(cut_status: "approved")
      end

      recommendation
    end

    private

    attr_reader :recommendation, :pin, :server_shift
  end
end
