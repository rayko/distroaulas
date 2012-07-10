# WeeklyCalendar by Dan McGrady 2011 http://dmix.ca
module WeeklyCalendar
  def weekly_calendar(objects, *args)
    #view helper to build the weekly calendar
    options = args.last.is_a?(Hash) ? args.pop : {}
    date = options[:date] || Time.now
    start_date = Date.new(date.year, date.month, date.day)
    row_title = options[:row_title]
    disable_day_name = options[:disable_day_name] || false
    main_title = options[:main_title]
    hours = options[:hours] # must be array like [16, 24] with start and end # 24 hour expected
    disable_onclick = options[:disable_onclick]

    if row_title.nil?
      end_date = Date.new(date.year, date.month, date.day) + 6
    else
      end_date = Date.new(date.year, date.month, date.day) # Weekly view for spaces
    end


    safe_concat(tag("div", :class => "week"))

      yield WeeklyCalendar::Builder.new(objects || [], self, options, start_date, end_date, row_title, disable_day_name, main_title, hours, disable_onclick)

    safe_concat("</div>")

    if options[:include_24_hours] == true
      safe_concat("<b><a href='?business_hours=true&start_date=#{start_date}'>Business Hours</a> | <a href='?business_hours=false&start_date=#{start_date}'>24-Hours</a></b>")
    end
    ""
  end

  def weekly_links(options)
    #view helper to insert the next and previous week links
    date = options[:date] || Time.now
    start_date = Date.new(date.year, date.month, date.day)
    end_date = Date.new(date.year, date.month, date.day) + 7
    safe_concat("<a href='?start_date=#{start_date - 7}?user_id='>&laquo; Previous Week</a> ")
    safe_concat("#{start_date.strftime("%B %d -")} #{end_date.strftime("%B %d")} #{start_date.year}")
    safe_concat(" <a href='?start_date=#{start_date + 7}?user_id='>Next Week &raquo;</a>")
  end
end
