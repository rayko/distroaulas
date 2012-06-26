class Plan < ActiveRecord::Base
  attr_accessible :name, :careers, :career_ids

  has_many :careers

  def self.to_xlsx
    records = self.all
    xlsx = Axlsx::Package.new

    xlsx.workbook do |wb|
      styles = wb.styles

      header = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER, :bg_color => '4b7399', :fg_color => 'FF', :b => true, :alignment => {:horizontal => :center})
      normal = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER)

      wb.add_worksheet(:name => self.model_name.human) do |sheet|
        sheet.add_row [self.human_attribute_name(:name)], :style => header, :widths => [30]
        records.each do |record|
          sheet.add_row [record.name], :style => normal
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

      wb.add_worksheet(:name => self.mmodel_name.human) do |sheet|
        sheet.add_row [self.human_attribute_name(:name)], :style => header, :widths => [30]
      end
    end
    return xlsx
  end

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
