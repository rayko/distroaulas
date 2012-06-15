class Matter < ActiveRecord::Base
  attr_accessible :name, :short_name, :career_id, :year, :career, :events,
                  :event_ids, :responsible

  belongs_to :career

  has_many :events

  def occurrences options={}
    until_date = options[:before] || Date.today + 5.years
    after_date = options[:after] || Date.new
    occurrences = []
    events = Event.find :all, :conditions => {:matter_id => self.id}
    events.each do |event|
      occurrences << event.to_rical.occurrences(:starting => after_date, :before => until_date)
    end
    return occurrences.flatten
  end

  # column order
  # 0-name 1-short_name 2-year 3-career 4-responsable
  def self.import_xls file=nil
    result = []
    if file
      matters_file = Spreadsheet.open file.path
      matters = matters_file.worksheet 'Matters'
      1.upto matters.row_count do |row_index|
        unless matters.row(row_index)[0].blank? || matters.row(row_index)[1].blank? || matters.row(row_index)[3].blank?
          matter = Matter.find_by_name matters.row(row_index)[0].strip

          unless matter
            career = Career.find_by_name matters.row(row_index)[3].strip
            if career

              matter = Matter.new :name => matters.row(row_index)[0].strip,
                                  :short_name => matters.row(row_index)[1],
                                  :career => career,
                                  :year => matters.row(row_index)[2],
                                  :responsable => matters.row(row_index)[4]

              if matter.save!
                result << "#{matters.row(row_index)[0]}... Saved!"
              else
                result << "#{matters.row(row_index)[0]}... Failed to save!"
              end

            else
              result << "#{matters.row(row_index)[0]}... Missing Career: #{matters.row(row_index)[3]}. Ignored."
            end

          else
            result << "#{matters.row(row_index)[0]}... Already exists. Ignored."
          end

        end
      end
    end
    if result.empty?
      result << "Nothing to import."
    end
    result << "Import finished!"
    return result
  end
end
