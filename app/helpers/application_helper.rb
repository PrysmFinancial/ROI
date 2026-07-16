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
    else "bg-roi-muted"
    end
  end
end
