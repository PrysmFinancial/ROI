class PagesController < ApplicationController
  def opening
  end

  def host
    @metrics = [
      { label: "Covers booked", value: "142", detail: "across 58 reservations", accent: false },
      { label: "Staff on", value: "6", detail: "5 servers · 1 floater", accent: false },
      { label: "Confirmations pending", value: "5", detail: "call before 5:30", accent: true },
      { label: "Walk-ins forecast", value: "~28", detail: "peak 8–9 pm", accent: false }
    ]

    @sections = [
      { zone: "Window", name: "Mara V.", initial: "M", detail: "T11–T14 · 4 tables" },
      { zone: "Dining (Front)", name: "Devin O.", initial: "D", detail: "T21–T22 · 2 tables" },
      { zone: "Dining (Back)", name: "Soren K.", initial: "S", detail: "T23–T24 · 2 tables" },
      { zone: "Bar", name: "Priya N.", initial: "P", detail: "B1–B4 · 4 seats" }
    ]

    @reservations = [
      { time: "6:30", name: "Aldous", note: "Window pref · still wine", covers: 2 },
      { time: "7:00", name: "Bianchi", note: "Regular · 7th visit", covers: 3 },
      { time: "7:15", name: "Okafor", note: "High top · celebration", covers: 4 },
      { time: "7:30", name: "Chen", note: "Quiet table · allergy", covers: 2 },
      { time: "7:45", name: "Rossi", note: "Bar seats · quick turn", covers: 2 },
      { time: "8:00", name: "Patel", note: "Booth pref · anniversary", covers: 2 },
      { time: "8:15", name: "Nguyen", note: "Walk-up hold · 6 covers", covers: 6 }
    ]
  end

  def host_floor
    @show_cut_modal = params[:cut] == "1"
    @floor_metrics = [
      { label: "Covers", value: "25" },
      { label: "Covers / hr", value: "11.4" },
      { label: "Servers on", value: "3" },
      { label: "Waitlist", value: "4 · 25 min" }
    ]

    @server_rows = [
      {
        label: "Mara V. · Window",
        tables: [
          { id: "T11", capacity: "2 top", guest: "Lindqvist", covers: 2, seated: "38m", status: :seated },
          { id: "T12", capacity: "4 top", guest: "Okafor", covers: 4, seated: "52m", status: :seated },
          { id: "T13", capacity: "2 top", guest: "Open", covers: nil, seated: nil, status: :open },
          { id: "T14", capacity: "4 top", guest: "Held · 5", covers: 5, seated: "15m", status: :held }
        ]
      },
      {
        label: "Devin O. · Dining",
        tables: [
          { id: "T21", capacity: "2 top", guest: "Walk-in", covers: 2, seated: "20m", status: :seated },
          { id: "T22", capacity: "4 top", guest: "Bianchi", covers: 3, seated: "61m", status: :seated },
          { id: "T23", capacity: "4 top", guest: "Open", covers: nil, seated: nil, status: :open },
          { id: "T24", capacity: "6 top", guest: "Adeyemi", covers: 7, seated: "44m", status: :seated }
        ]
      },
      {
        label: "Priya N. · Bar",
        tables: [
          { id: "B1", capacity: "2 seats", guest: "Rossi", covers: 2, seated: "27m", status: :seated },
          { id: "B2", capacity: "2 seats", guest: "Tan", covers: 2, seated: "12m", status: :seated },
          { id: "B3", capacity: "2 seats", guest: "Open", covers: nil, seated: nil, status: :open },
          { id: "B4", capacity: "2 seats", guest: "Open", covers: nil, seated: nil, status: :open }
        ]
      }
    ]

    @queue = [
      {
        name: "Vasquez",
        meta: "8:30 reservation · 2 covers",
        tags: [ "VIP", "14 visits" ],
        recommend: "ROI recommends T13 · Mara V."
      },
      {
        name: "Ferraro",
        meta: "Walk-in · quoted 25 min · 2 covers",
        tags: [],
        recommend: "ROI recommends B3 · Priya N."
      },
      {
        name: "Cho",
        meta: "8:30 reservation · 4 covers",
        tags: [],
        recommend: "ROI recommends T23 · Devin O."
      },
      {
        name: "Delacroix",
        meta: "8:45 reservation · 3 covers",
        tags: [ "Recovery" ],
        recommend: "ROI recommends T23 · Devin O."
      }
    ]
  end

  def host_confirmations
    @confirmation_counts = { confirmed: 1, pending: 5 }
    @confirmation_calls = [
      { time: "7:00", name: "Bianchi", covers: 3, table: "T22", note: "Regular · still wine", status: :confirmed },
      { time: "7:30", name: "Okafor", covers: 4, table: "T12", note: "Birthday · cake at 9", status: :pending },
      { time: "8:00", name: "Adeyemi", covers: 7, table: "T24", note: "Allergy: shellfish", status: :pending },
      { time: "8:30", name: "Vasquez", covers: 2, table: "T13", note: "VIP · anniversary", status: :pending },
      { time: "8:45", name: "Mortensen", covers: 6, table: "T14", note: "High chair x1", status: :pending },
      { time: "9:00", name: "Delacroix", covers: 3, table: "—", note: "Recovery flag", status: :pending }
    ]
  end

  def manager
  end
end
