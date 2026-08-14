module ApplicationHelper
  def host_tab_classes(active_tab, tab)
    base = "rounded-full px-4 py-2 text-sm transition-colors md:px-5"
    if active_tab.to_s == tab.to_s
      "#{base} bg-roi-surface-raised font-medium text-roi-text"
    else
      "#{base} text-roi-muted hover:text-roi-text"
    end
  end

  def table_status_dot(status)
    case status.to_sym
    when :seated then "bg-roi-seated"
    when :open then "bg-roi-open"
    when :held then "bg-roi-held"
    when :bill then "bg-roi-warning"
    else "bg-roi-muted"
    end
  end

  def manager_score_ring(tone)
    case tone.to_sym
    when :high then "border-roi-success text-roi-success"
    when :mid then "border-roi-warning text-roi-warning"
    else "border-roi-danger text-roi-danger"
    end
  end

  def manager_fairness_bar(pct)
    if pct >= 80
      "bg-roi-success"
    elsif pct >= 72
      "bg-roi-warning"
    else
      "bg-roi-danger"
    end
  end

  def manager_vs_tone(tone)
    tone.to_sym == :up ? "text-roi-success" : "text-roi-danger"
  end
end
