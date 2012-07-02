class Career < ActiveRecord::Base
  attr_accessible :name, :short_name, :plan, :plan_id, :matters, :matter_ids

  belongs_to :plan
  has_many :matters

  def self.to_xlsx
    records = self.all
    xlsx = Axlsx::Package.new

    xlsx.workbook do |wb|
      styles = wb.styles

      header = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER, :bg_color => '4b7399', :fg_color => 'FF', :b => true, :alignment => {:horizontal => :center})
      normal = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER)

      wb.add_worksheet(:name => self.model_name.human) do |sheet|
        sheet.add_row [self.human_attribute_name(:name),
                       self.human_attribute_name(:short_name),
                       self.human_attribute_name(:plan)], :style => header, :widths => [30, 30, 30]
        records.each do |record|
          sheet.add_row [record.name,
                         record.short_name,
                         record.plan.name], :style => normal
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
        sheet.add_row [self.human_attribute_name(:name) + ' (*)',
                       self.human_attribute_name(:short_name),
                       self.human_attribute_name(:plan) + ' (*)'], :style => header, :widths => [30, 30, 30]
      end
    end
    return xlsx
  end

  # column order
  # 0-name 1-short_name 2-plan_name
  def self.import_xls file=nil
    result = []
    if file
      careers_file = Spreadsheet.open file.path
      careers = careers_file.worksheet 'Careers'
      counters = { :all => -1, :saved => 0, :not_saved => 0 }
      1.upto careers.row_count do |row_index|
        counters[:all] += 1
        unless careers.row(row_index)[0].blank? || careers.row(row_index)[2].blank?
          career = Career.find_by_name careers.row(row_index)[0].strip

          unless career
            plan = Plan.find_by_name careers.row(row_index)[2].to_s
            if plan

              career = Career.new :name => careers.row(row_index)[0].strip,
                                  :plan => plan,
                                  :short_name => careers.row(row_index)[1]

              if career.save!
                result << I18n.t('activerecord.career_import_info.saved', :name => careers.row(row_index)[0])
                counters[:saved] += 1
              else
                result << I18n.t('activerecord.career_import_info.not_saved', :name => careers.row(row_index)[0])
                counters[:not_saved] += 1
              end

            else
              result << I18n.t('activerecord.career_import_info.missing_plan', :name => careers.row(row_index)[0], :plan => careers.row(row_index)[1])
              counters[:not_saved] += 1
            end

          else
            result << I18n.t('activerecord.career_import_info.duplicated', :name => careers.row(row_index)[0])
            counters[:not_saved] += 1
          end

        end
      end
    end
    if result.empty?
      result << I18n.t('activerecord.career_import_info.empty')
    end
    result << I18n.t('activerecord.career_import_info.finished')
    result << I18n.t('activerecord.career_import_info.count', :all => counters[:all], :saved => counters[:saved], :not_saved => counters[:not_saved])
    return result
  end


end
