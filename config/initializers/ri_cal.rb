require 'ri_cal'

class RiCal::Component::Event
  attr_accessor :space, :related_object

  def starts_at
    self.dtstart
  end

  def ends_at
    self.dtend
  end

  def id
    self.related_object.id
  end

  def name
    self.related_object.name
  end
end
