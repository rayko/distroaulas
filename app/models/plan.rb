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

      wb.add_worksheet(:name => self.model_name.human) do |sheet|
        sheet.add_row [self.human_attribute_name(:name) + ' (*)'], :style => header, :widths => [30]
      end
    end
    return xlsx
  end

  def self.import_xls file=nil

    result = []
    if file
      plans_file = Spreadsheet.open file.path
      plans = plans_file.worksheet Plan.model_name.human
      counters = {:all => -1, :saved => 0, :not_saved => 0}
      1.upto plans.row_count do |row_index|
        counters[:all] += 1
        name = plans.row(row_index)[0].to_s.strip
        unless name.blank?
          plan = Plan.find_by_name name

          unless plan
            plan = Plan.new :name => name
            if plan.save!
              result << I18n.t('activerecord.plan_import_info.saved', :name => name)
              counters[:saved] += 1
            else
              result << I18n.t('activerecord.plan_import_info.not_saved', :name => name)
              counters[:not_saved] += 1
            end
          else
            result << I18n.t('activerecord.plan_import_info.duplicated', :name => name)
            counters[:not_saved] += 1
          end
        end
      end
    end
    if result.empty?
      result << I18n.t('activerecord.plan_import_info.empty')
    end
    result << I18n.t('activerecord.plan_import_info.finished')
    result << I18n.t('activerecord.plan_import_info.count', :all => counters[:all], :saved => counters[:saved], :not_saved => counters[:not_saved])
    return result

  end
end
