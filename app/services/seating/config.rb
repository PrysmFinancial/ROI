module Seating
  # Locked Host P2 defaults from seating-spec suggestions (D-02 / D-03).
  # VIP/capability hard filters stay off until self-baseline hustle lands (D-01).
  module Config
    FAIRNESS_BAND = 0.15
    IDLE_MINUTES = 8
  end
end
