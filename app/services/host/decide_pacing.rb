module Host
  class DecidePacing
    def self.call(recommendation:, decision:)
      new(recommendation, decision).call
    end

    def initialize(recommendation, decision)
      @recommendation = recommendation
      @decision = decision.to_s
      @shift = recommendation.shift
    end

    def call
      raise ArgumentError, "Invalid decision" unless decision.in?(%w[confirmed declined])

      ActiveRecord::Base.transaction do
        recommendation.update!(status: decision, decided_at: Time.current)

        if decision == "confirmed"
          shift.update!(pacing_hold_until: recommendation.hold_minutes.minutes.from_now)
        end
      end

      recommendation
    end

    private

    attr_reader :recommendation, :decision, :shift
  end
end
