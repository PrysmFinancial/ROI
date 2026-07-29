# Demo shift matching Host1–4 screenshots. Idempotent for local development.
puts "Seeding ROI Host demo..."

ActiveRecord::Base.transaction do
  SeatingRecommendation.delete_all
  PacingRecommendation.delete_all
  CutRecommendation.delete_all
  Party.delete_all
  DiningTable.delete_all
  Section.delete_all
  ServerShift.delete_all
  Server.delete_all
  Shift.delete_all

  shift = Shift.create!(
    service_date: Date.new(2026, 6, 6),
    location_name: "The Hearth Room",
    rush_mode: false,
    sections_approved: false,
    manager_pin: "1234"
  )

  servers = {
    mara: Server.create!(name: "Mara V.", initial: "M", capability: "strong", baseline_covers_per_hour: 11.0),
    devin: Server.create!(name: "Devin O.", initial: "D", capability: "standard", baseline_covers_per_hour: 10.5),
    soren: Server.create!(name: "Soren K.", initial: "S", capability: "strong", baseline_covers_per_hour: 12.0),
    priya: Server.create!(name: "Priya N.", initial: "P", capability: "standard", baseline_covers_per_hour: 9.0),
    lila: Server.create!(name: "Lila R.", initial: "L", capability: "new", baseline_covers_per_hour: 8.0),
    floater: Server.create!(name: "Alex F.", initial: "A", capability: "standard", baseline_covers_per_hour: 10.0)
  }

  server_shifts = {
    mara: ServerShift.create!(shift:, server: servers[:mara], start_order: 1, clocked_in_at: Time.zone.parse("2026-06-06 16:00"), covers_tonight: 38, covers_per_hour: 12.1),
    devin: ServerShift.create!(shift:, server: servers[:devin], start_order: 2, clocked_in_at: Time.zone.parse("2026-06-06 16:30"), covers_tonight: 41, covers_per_hour: 11.4),
    soren: ServerShift.create!(shift:, server: servers[:soren], start_order: 3, clocked_in_at: Time.zone.parse("2026-06-06 17:00"), covers_tonight: 44, covers_per_hour: 13.8),
    priya: ServerShift.create!(shift:, server: servers[:priya], start_order: 4, clocked_in_at: Time.zone.parse("2026-06-06 17:00"), covers_tonight: 22, covers_per_hour: 8.9),
    lila: ServerShift.create!(shift:, server: servers[:lila], start_order: 5, clocked_in_at: Time.zone.parse("2026-06-06 17:30"), covers_tonight: 19, covers_per_hour: 7.6),
    floater: ServerShift.create!(shift:, server: servers[:floater], start_order: 6, clocked_in_at: Time.zone.parse("2026-06-06 18:00"), covers_tonight: 8, covers_per_hour: 9.0)
  }

  sections = {
    window: Section.create!(shift:, name: "Window", position: 1, server_shift: server_shifts[:mara]),
    dining_front: Section.create!(shift:, name: "Dining (Front)", position: 2, server_shift: server_shifts[:devin]),
    dining_back: Section.create!(shift:, name: "Dining (Back)", position: 3, server_shift: server_shifts[:soren]),
    bar: Section.create!(shift:, name: "Bar", position: 4, server_shift: server_shifts[:priya])
  }

  tables = {}
  {
    window: [ [ "T11", 2 ], [ "T12", 4 ], [ "T13", 2 ], [ "T14", 4 ] ],
    dining_front: [ [ "T21", 2 ], [ "T22", 4 ] ],
    dining_back: [ [ "T23", 4 ], [ "T24", 6 ] ],
    bar: [ [ "B1", 2 ], [ "B2", 2 ], [ "B3", 2 ], [ "B4", 2 ] ]
  }.each do |section_key, defs|
    defs.each do |label, capacity|
      tables[label] = DiningTable.create!(section: sections[section_key], label:, capacity:, status: "open")
    end
  end

  # Floor state (Host3)
  seated = [
    [ "T11", "Lindqvist", 2, 38 ],
    [ "T12", "Okafor", 4, 52 ],
    [ "T21", "Walk-in", 2, 20 ],
    [ "T22", "Bianchi", 3, 61 ],
    [ "T24", "Adeyemi", 7, 44 ],
    [ "B1", "Rossi", 2, 27 ],
    [ "B2", "Tan", 2, 12 ]
  ]
  seated.each do |label, name, covers, minutes|
    table = tables[label]
    table.update!(status: "seated", seated_at: minutes.minutes.ago)
    Party.create!(
      shift:,
      name:,
      covers:,
      source: name == "Walk-in" ? "walk_in" : "reservation",
      lifecycle: "seated",
      dining_table: table,
      server_shift: table.section.server_shift,
      confirmation_status: "confirmed",
      note: ""
    )
  end

  tables["T14"].update!(status: "held")
  Party.create!(
    shift:,
    name: "Held party",
    covers: 5,
    source: "reservation",
    lifecycle: "held",
    dining_table: tables["T14"],
    server_shift: server_shifts[:mara],
    confirmation_status: "confirmed",
    reservation_time: "20:15",
    note: "Table hold",
    tags: [ "VIP" ]
  )

  # Book / confirmation list (Host1 + Host4)
  book = [
    [ "18:30", "Aldous", 2, "Window pref · still wine", "pending", nil ],
    [ "19:00", "Bianchi", 3, "Regular · still wine", "confirmed", "T22" ],
    [ "19:15", "Okafor", 4, "Birthday · cake at 9", "pending", "T12" ],
    [ "19:30", "Chen", 2, "Quiet table · allergy", "pending", nil ],
    [ "19:45", "Rossi", 2, "Bar seats · quick turn", "pending", "B1" ],
    [ "20:00", "Adeyemi", 7, "Allergy: shellfish", "pending", "T24" ],
    [ "20:00", "Patel", 2, "Booth pref · anniversary", "pending", nil ],
    [ "20:15", "Nguyen", 6, "Walk-up hold · 6 covers", "pending", nil ],
    [ "20:30", "Vasquez", 2, "VIP · anniversary", "pending", "T13" ],
    [ "20:45", "Mortensen", 6, "High chair x1", "pending", "T14" ],
    [ "21:00", "Delacroix", 3, "Recovery flag", "pending", nil ]
  ]

  book.each do |time, name, covers, note, confirmation, table_label|
    next if Party.exists?(shift:, name:, lifecycle: "seated")

    Party.create!(
      shift:,
      name:,
      covers:,
      note:,
      source: "reservation",
      reservation_time: time,
      confirmation_status: confirmation,
      lifecycle: "booked",
      dining_table: table_label ? tables[table_label] : nil,
      tags: note.include?("VIP") ? [ "VIP" ] : (note.include?("Recovery") ? [ "Recovery" ] : [])
    )
  end

  # Ensure confirmation-call parties match Host4 even if some names were seated under floor
  {
    "Bianchi" => [ "19:00", 3, "T22", "Regular · still wine", "confirmed" ],
    "Okafor" => [ "19:30", 4, "T12", "Birthday · cake at 9", "pending" ],
    "Adeyemi" => [ "20:00", 7, "T24", "Allergy: shellfish", "pending" ],
    "Vasquez" => [ "20:30", 2, "T13", "VIP · anniversary", "pending" ],
    "Mortensen" => [ "20:45", 6, "T14", "High chair x1", "pending" ],
    "Delacroix" => [ "21:00", 3, nil, "Recovery flag", "pending" ]
  }.each do |name, (time, covers, table_label, note, status)|
    party = Party.find_or_initialize_by(shift:, name:, source: "reservation", reservation_time: time)
    party.assign_attributes(
      covers:,
      note:,
      confirmation_status: status,
      lifecycle: party.lifecycle.presence || "booked",
      dining_table: table_label ? tables[table_label] : party.dining_table,
      tags: note.include?("VIP") ? [ "VIP" ] : (note.include?("Recovery") ? [ "Recovery" ] : [])
    )
    party.save!
  end

  # Seating queue (Host3)
  queue = [
    [ "Vasquez", "reservation", "20:30", 2, [ "VIP", "14 visits" ], "T13", :mara ],
    [ "Ferraro", "walk_in", nil, 2, [], "B3", :priya ],
    [ "Cho", "reservation", "20:30", 4, [], "T23", :devin ],
    [ "Delacroix", "reservation", "20:45", 3, [ "Recovery" ], "T23", :devin ]
  ]

  queue.each_with_index do |(name, source, time, covers, tags, table_label, server_key), index|
    party = Party.find_by(shift:, name:, lifecycle: "booked") ||
            Party.find_or_initialize_by(shift:, name:)
    party.assign_attributes(
      covers:,
      source:,
      reservation_time: time,
      tags:,
      lifecycle: "waiting",
      queue_position: index + 1,
      quoted_wait_minutes: source == "walk_in" ? 25 : nil,
      note: party.note.presence || (tags.include?("Recovery") ? "Recovery flag" : ""),
      confirmation_status: party.confirmation_status.presence || "pending"
    )
    party.save!

    Seating::AssignmentEngine.call(party:)
    # Prefer screenshot recommendations when tables are still open
    table = tables[table_label]
    if table.status == "open"
      party.seating_recommendation.update!(
        dining_table: table,
        server_shift: server_shifts[server_key],
        summary: "ROI recommends #{table.label} · #{server_shifts[server_key].name}",
        status: "open"
      )
    end
  end

  PacingRecommendation.create!(
    shift:,
    message: "Kitchen at 82% — hold the 8:30 window seat 10 minutes.",
    hold_minutes: 10,
    status: "open"
  )

  CutRecommendation.create!(
    shift:,
    server_shift: server_shifts[:priya],
    reason: "Bar load is winding down and late demand is predicted soft.",
    status: "open"
  )
end

puts "Seeded shift #{Shift.current.id} for #{Shift.current.service_date} at #{Shift.current.location_name}."
puts "Demo manager PIN: #{Shift.current.manager_pin}"
