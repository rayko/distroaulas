class Plan < ActiveRecord::Base
  attr_accessible :name, :careers, :career_ids

  has_many :careers

  def self.import_xls file=nil

    result = []
    if file
      plans_file = Spreadsheet.open file.path
      plans = plans_file.worksheet 'Plans'
      1.upto plans.row_count do |row_index|
        unless plans.row(row_index)[0].blank?
          plan = Plan.find_by_name plans.row(row_index)[0].to_s

          unless plan
            plan = Plan.new :name => plans.row(row_index)[0]
            if plan.save!
              result << "#{plans.row(row_index)[0]}... Saved!"
            else
              result << "#{plans.row(row_index)[0]}... Failed to save!"
            end
          else
            result << "#{plans.row(row_index)[0]}... Already exists. Ignored."
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
