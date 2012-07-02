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
      space_types = space_types_file.worksheet SpaceType.model_name.human
      counters = { :all => -1, :saved => 0, :not_saved => 0 }
      1.upto space_types.row_count do |row_index|
        counters[:all] += 1
        unless space_types.row(row_index)[0].blank?
          space_type = SpaceType.find_by_name space_types.row(row_index)[0].strip
          unless space_type
            space_type = SpaceType.new :name => space_types.row(row_index)[0]
            if space_type.save!
              result << I18n.t('activerecord.space_type_import_info.saved', :name => space_types.row(row_index)[0])
              counters[:saved] += 1
            else
              result << I18n.t('activerecord.space_type_import_info.not_saved', :name => space_types.row(row_index)[0])
              counters[:not_saved] += 1
            end
          else
            result << I18n.t('activerecord.space_type_import_info.duplicated', :name => space_types.row(row_index)[0])
            counters[:not_saved] += 1
          end
        end
      end
    end
    if result.empty?
      result << I18n.t('activerecord.space_type_import_info.empty')
    end
    result << I18n.t('activerecord.space_type_import_info.finished')
    result << I18n.t('activerecord.space_type_import_info.count', :all => counters[:all], :saved => counters[:saved], :not_saved => counters[:not_saved])
    return result
  end
end
