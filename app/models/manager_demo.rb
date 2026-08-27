# Hardcoded Manager screenshot mock data (UI-only shells). Not wired to Shift/seed yet.
module ManagerDemo
  LOCATION = "The Hearth Room"

  def self.kpis
    [
      { label: "Covers tonight", value: "142", detail: "▲ 12% vs. last Fri", tone: :up },
      { label: "Covers / hr", value: "11.4", detail: "on pace", tone: :neutral },
      { label: "Net sales", value: "$8,420", detail: "▲ 12%", tone: :up },
      { label: "Avg turn", value: "68 min", detail: "▼ 6 min slower", tone: :down },
      { label: "Servers on", value: "5", detail: "cut due 9:05", tone: :neutral },
      { label: "Waitlist", value: "4", detail: "quoted 25 min", tone: :neutral }
    ]
  end

  def self.floor_status
    [
      { label: "Seated", value: 6, tone: :seated },
      { label: "Bill", value: 2, tone: :bill },
      { label: "Held", value: 1, tone: :held },
      { label: "Open", value: 3, tone: :open }
    ]
  end

  def self.servers_on
    [
      { name: "Mara V.", section: "Window", covers: 38, pace: "High.", cov_hr: "12.1", vs_base: "+1.3", vs_tone: :up, badge: nil },
      { name: "Devin O.", section: "Dining", covers: 41, pace: "On pace.", cov_hr: "11.4", vs_base: "−0.2", vs_tone: :down, badge: nil },
      { name: "Priya N.", section: "Bar", covers: 22, pace: "Easing.", cov_hr: "8.9", vs_base: "−0.5", vs_tone: :down, badge: nil },
      { name: "Soren K.", section: "Dining", covers: 44, pace: "High.", cov_hr: "13.8", vs_base: "+2.6", vs_tone: :up, badge: "In the weeds" },
      { name: "Lila R.", section: "Patio", covers: 19, pace: "Light.", cov_hr: "7.6", vs_base: "−1.4", vs_tone: :down, badge: nil }
    ]
  end

  def self.pacing
    {
      kitchen_pct: 82,
      floor_label: "On pace",
      floor_pct: 64,
      late_demand: "Soft",
      late_pct: 28,
      cut_name: "Priya N.",
      cut_time: "9:05"
    }
  end

  def self.tonight_feed
    [
      { time: "8:22", text: "T24 — Adeyemi ordered dessert · server Soren" },
      { time: "8:19", text: "B2 — Tan bill dropped · $86.50" },
      { time: "8:15", text: "T14 — Lindqvist held, 5 covers · 15 min" },
      { time: "8:04", text: "T21 — walk-in seated, 2 covers" }
    ]
  end

  def self.tools
    [
      { path_helper: :manager_staffing_path, title: "Staffing intelligence", detail: "Pre-shift + live cut recommendations", icon: :staffing },
      { path_helper: :manager_performance_path, title: "Server performance", detail: "Covers, pace vs. baseline, fairness", icon: :performance },
      { path_helper: :manager_no_shows_path, title: "No-show list", detail: "3 tonight · guest-score effect", icon: :noshow },
      { path_helper: :manager_guests_path, title: "Guest intelligence", detail: "GM-only · scores, history, recovery", icon: :guests }
    ]
  end

  def self.guests
    [
      { score: 94, grade: "A", tone: :high, name: "Amara Vasquez", stats: "14 visits · $340 avg · since 2021", tags: %w[HNW VIP], last: "Anniversary · 8 days ago", note: "Seat in Mara's section" },
      { score: 61, grade: "B", tone: :mid, name: "Marc Delacroix", stats: "5 visits · $180 avg · since 2021", tags: %w[Recovery], last: "Slow service · recovery owed", note: "Comp dessert on next visit" },
      { score: 38, grade: "C", tone: :low, name: "J. Pemberton", stats: "3 visits · $120 avg · since 2021", tags: [ "At risk" ], last: "2 no-shows · 90 days", note: "Standard service" }
    ]
  end

  def self.no_shows
    [
      { name: "J. Pemberton", time: "7:30", effect: "Score −12 · At risk", note: "Second no-show in 90 days" },
      { name: "Chen party", time: "8:00", effect: "Score −6", note: "Called after hold released" },
      { name: "Walk-up hold", time: "8:15", effect: "—", note: "No profile · released table" }
    ]
  end
end
