module ApplicationHelper

  def formatted_date(date)
    date.strftime("%y %B %d")
  end

  def formatted_time(date)
    date.strftime("%H:%M:%S")
  end
end
