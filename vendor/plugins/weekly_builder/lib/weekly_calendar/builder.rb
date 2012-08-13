class WeeklyCalendar::Builder
  include ::ActionView::Helpers::TagHelper

  def initialize(objects, template, options, start_date, end_date, row_title, disable_day_name, main_title, hours, disable_onclick)
    raise ArgumentError, "WeeklyBuilder expects an Array but found a #{objects.inspect}" unless objects.is_a? Array
    @objects, @template, @options, @start_date, @end_date, @row_title, @disable_day_name, @main_title, @hours, @disable_onclick = objects, template, options, start_date, end_date, row_title, disable_day_name, main_title, hours, disable_onclick
  end

  def days
    concat(tag("div", :class => "days"))
    if @main_title
      concat(content_tag("div", @main_title, :class => "placeholder"))
    else
      concat(content_tag("div", 'WeeklyCalendar', :class => "placeholder"))
    end
      for day in @start_date..@end_date
        concat(tag("div", :class => "day"))
        unless @disable_day_name
          concat(content_tag("b", I18n.l(day, :format => :only_day)))
          concat(tag("br"))
          concat(I18n.l(day, :format => :short))
          concat(tag("br"))
        end
        concat(@row_title) unless @row_title.nil?
        concat("</div>")
      end
    concat("</div>")
  end

  def week(options = {})
    days
    if @hours
      hstart = Time.parse "#{@hours[0]}:00"
      if @hours.size == 2
        hend = Time.parse "#{@hours[1]}:00"
      else
        hend = Time.parse "23:00"
      end
      hours = []
      start_hour = hstart.strftime('%k').to_i
      end_hour = hend.strftime('%k').to_i
      while hstart <= hend
        hours << hstart.strftime('%H')
        hstart += 1.hours
      end
      header_row = "header_row"
      day_row = "day_row"
      grid = "grid"
    elsif options[:business_hours] == "true" or options[:business_hours].blank?
      hours = ["13","14","15","16","17","18","19","20","21","22","23"]
      header_row = "header_row"
      day_row = "day_row"
      grid = "grid"
      start_hour = 13
      end_hour = 23
    else
      hours = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","00"]
      header_row = "full_header_row"
      day_row = "full_day_row"
      grid = "full_grid"
      start_hour = 1
      end_hour = 24
    end

    concat(tag("div", :class => "hours"))
      concat(tag("div", :class => header_row))
        for hour in hours
          header_box = "<b>#{hour}</b>".html_safe
          concat(content_tag("div", header_box, :class => "header_box"))
        end
      concat("</div>")

      concat(tag("div", :class => grid))
        for day in @start_date..@end_date
          concat(tag("div", :class => day_row))
          for event in @objects
            if event.starts_at.strftime('%j').to_s == day.strftime('%j').to_s
             if event.starts_at.strftime('%H').to_i >= start_hour and event.ends_at.strftime('%H').to_i <= end_hour
               if @disable_onclick
                 concat(tag("div", :class => "week_event", :style =>"left:#{left(event.starts_at,options[:business_hours])}px;width:#{width(event.starts_at,event.ends_at)}px;"))
               else
                 concat(tag("div", :class => "week_event", :style =>"left:#{left(event.starts_at,options[:business_hours])}px;width:#{width(event.starts_at,event.ends_at)}px;", :onclick => "location.href='/events/#{event.id}';"))
               end
                  truncate = truncate_width(width(event.starts_at,event.ends_at))
                  yield(event,truncate)
                concat("</div>")
              end
            end
          end
          concat("</div>")
        end
      concat("</div>")
    concat("</div>")
  end

  private

  def concat(tag)
    @template.safe_concat(tag)
    ""
  end

  def left(starts_at,business_hours)
    if @hours
      minutes = starts_at.strftime('%M').to_f * 1.25
      hour = starts_at.strftime('%H').to_f - @hours[0]
    elsif business_hours == "true" or business_hours.blank?
      minutes = starts_at.strftime('%M').to_f * 1.25
      hour = starts_at.strftime('%H').to_f - 13
    else
      minutes = starts_at.strftime('%M').to_f * 1.25
      hour = starts_at.strftime('%H').to_f
    end
    left = (hour * 75) + minutes
  end

  def width(starts_at,ends_at)
    #example 3:30 - 5:30
    start_hours = starts_at.strftime('%H').to_i * 60 # 3 * 60 = 180
    start_minutes = starts_at.strftime('%M').to_i + start_hours # 30 + 180 = 210
    end_hours = ends_at.strftime('%H').to_i * 60 # 5 * 60 = 300
    end_minutes = ends_at.strftime('%M').to_i + end_hours # 30 + 300 = 330
    difference =  (end_minutes.to_i - start_minutes.to_i) * 1.25 # (330 - 180) = 150 * 1.25 = 187.5

    unless difference < 12 # original -> difference < 60 but it doesn't allow events of 30 minutes for example
      width = difference - 12
    else
      width = 63 #default width (75px minus padding+border)
    end
  end

  def truncate_width(width)
    hours = width / 63
    truncate_width = 20 * hours
  end
end
