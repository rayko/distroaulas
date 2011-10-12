module CalendarsHelper

  def weekly
    calendar = ''
    calendar += tag 'div', :class => 'weekly-calendar'

    calendar += weekly_days

    calendar += weekly_hours[1]
    calendar += events_containers
    calendar += "</div>"

    return raw calendar
  end

  def events_containers
    days = [1,2,3,4,5,6,7]
    containers = '<div class="event-containers">'
    days.each do |day|
      containers += "<div class=\"day-#{day}\">lol</div>"
    end
    containers += '</div>'
    return containers
  end

  def weekly_hours tstart=Time.parse("13:00"), tend=Time.parse("23:00"), interval=30
    hours = []

    while tstart < tend
      hours << tstart.strftime("%H:%M")
      tstart += 30.minutes
    end

    weekly_hours = '<div class="weekly-hours">'
    hours.each do |hour|
      weekly_hours += "<div>#{hour}</div>"
    end
    weekly_hours += '</div>'
    height = hours.size * 30

    return [height, weekly_hours]
  end

  def weekly_days
    days = ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab']
    div_days = '<div class="weekly-days">'
    days.each do |day|
      div_days += "<div>#{day}</div>"
    end
    div_days += "</div>"

    return div_days
  end

end
