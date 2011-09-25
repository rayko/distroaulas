class ReccurrenceRule
  attr_accessor :frequency, :interval, :until_date, :byday, :count

  def initialize options={}
    options.each_key do |key|
      if self.respond_to? "#{key}=".to_sym
        self.send "#{key}=".to_sym, (options[key].blank? ? nil : options[key])
      end
    end
  end

  def to_rical
    unless self.frequency.blank?
      rrule = "FREQ=#{self.frequency};"
    else
      return false
    end
    unless self.interval.nil?
      rrule += "INTERVAL=#{self.interval};"
    end
    unless self.until_date.nil?
      rrule += "UNTIL=#{self.until_date};"
    end
    unless self.byday.nil?
      rrule += "BYDAY=#{self.byday};"
    end
    unless self.count.nil?
      rrule += "COUNT=#{self.count};"
    end
    return rrule
  end

  def load_rule event
    if event.respond_to? :rrule=
      event.send :rrule=, self.to_rical
    end
  end
end
