module Host
  class AdjustSection
    class InvalidServerError < StandardError; end

    def self.call(section:, server_shift:)
      new(section, server_shift).call
    end

    def initialize(section, server_shift)
      @section = section
      @server_shift = server_shift
    end

    def call
      unless server_shift.shift_id == section.shift_id
        raise InvalidServerError, "Server is not on this shift"
      end

      ActiveRecord::Base.transaction do
        # Move: free this server from any other section, then assign here.
        Section.where(shift_id: section.shift_id, server_shift_id: server_shift.id)
          .where.not(id: section.id)
          .update_all(server_shift_id: nil)

        section.update!(server_shift: server_shift)
      end

      section
    end

    private

    attr_reader :section, :server_shift
  end
end
