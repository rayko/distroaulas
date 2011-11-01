class SpaceType < ActiveRecord::Base
  attr_accessible :name

  require 'spreadsheet'

  # column order
  # 0-name
  def self.import_xls file=nil
    result = []
    if file
      space_types_file = Spreadsheet.open file.path
      space_types = space_types_file.worksheet 'Space Types'
      1.upto space_types.row_count do |row_index|
        unless space_types.row(row_index)[0].blank?
          space_type = SpaceType.find_by_name space_types.row(row_index)[0].strip
          unless space_type
            space_type = SpaceType.new :name => space_types.row(row_index)[0]
            if space_type.save!
              result << "#{space_types.row(row_index)[0]}... Saved!"
            else
              result << "#{space_types.row(row_index)[0]}... Failed to save!"
            end
          else
            result << "#{space_types.row(row_index)[0]}... Already exists. Ignored."
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
