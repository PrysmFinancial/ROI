module Host
  class LogDecision
    def self.call(shift:, kind:, summary:, detail: "", party: nil)
      DecisionEvent.create!(
        shift:,
        party:,
        kind:,
        summary:,
        detail: detail.to_s
      )
    end
  end
end
