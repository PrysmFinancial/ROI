module Host
  class UpdateConfirmation
    def self.call(party:, status:)
      new(party, status).call
    end

    def initialize(party, status)
      @party = party
      @status = status.to_s
    end

    def call
      raise ArgumentError, "Invalid status" unless status.in?(Party::CONFIRMATION_STATUSES)

      party.update!(confirmation_status: status)
      party
    end

    private

    attr_reader :party, :status
  end
end
