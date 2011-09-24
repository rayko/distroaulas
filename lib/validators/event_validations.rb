module EventCustomValidations

  class PeriodValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:dtstart] << "Invalid period" unless check_period(record)
      record.errors[:dtend] << "Invalid period" unless check_period(record)
    end
    private
    def check_period(record)
      unless record.dtstart.nil? or record.dtend.nil?
        return record.dtend > record.dtstart
      else
        return false
      end
    end
  end

  class StartDateValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:dtstart] << "Invalid date" unless check_dtstart(record)
    end
    private
    def check_dtstart(record)
      unless record.dtstart.nil?
        return record.dtstart > DateTime.now
      else
        return false
      end
    end
  end

end

