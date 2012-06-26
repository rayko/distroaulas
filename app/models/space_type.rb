class SpaceType < ActiveRecord::Base
  attr_accessible :name

  has_many :spaces

  require 'spreadsheet'
  require 'axlsx'


  def self.to_xlsx
    records = SpaceType.all
    xlsx = Axlsx::Package.new

    xlsx.workbook do |wb|
      styles = wb.styles

      header = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER, :bg_color => '4b7399', :fg_color => 'FF', :b => true, :alignment => {:horizontal => :center})
      normal = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER)

      wb.add_worksheet(:name => self.model_name.human) do |sheet|
        sheet.add_row [self.human_attribute_name(:name)], :style => header, :widths => [30]
        records.each do |space_type|
          sheet.add_row [space_type.name], :style => normal
        end

      end
    end
    return xlsx
  end

  def self.generate_import_template
    xlsx = Axlsx::Package.new

    xlsx.workbook do |wb|
      styles = wb.styles

      header = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER, :bg_color => '4b7399', :fg_color => 'FF', :b => true, :alignment => {:horizontal => :center})

      wb.add_worksheet(:name => self.model_name.human) do |sheet|
        sheet.add_row [self.human_attribute_name(:name) + ' (*)'], :style => header, :widths => [30]
      end
    end
    return xlsx
  end

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
