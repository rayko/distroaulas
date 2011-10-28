module EventCustomValidations

  class PeriodValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:start_time] << "Invalid period" unless check_period(record)
      record.errors[:end_time] << "Invalid period" unless check_period(record)
    end
    private
    def check_period(record)
      unless record.start_time.nil? or record.end_time.nil?
        return record.start_time < record.end_time
      else
        return false
      end
    end
  end

  class StartDateValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:start_date] << "Invalid date" unless check_dtstart(record)
    end
    private
    def check_dtstart(record)
      unless record.start_date.nil?
        return record.start_date >= Date.today
      else
        return false
      end
    end
  end

  class OverlappingValidator < ActiveModel::Validator
    def validate(record)
      master_calendar = []
      Event.all.each do |event|
        master_calendar << event.to_rical
      end

    end
  end

  class UntilDateValidator < ActiveModel::Validator
    def validate(record)
      if record.recurrent
        if record.until_date.blank?
          record.errors[:until_date] << "Can't be blank"
        end
      end
    end
  end

end

