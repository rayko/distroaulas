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
                       self.human_attribute_name(:year),
                       self.human_attribute_name(:career),
                       self.human_attribute_name(:responsible)], :style => header, :widths => [30, 30, 30, 30, 30]
        records.each do |record|
          sheet.add_row [record.name,
                         record.short_name,
                         record.year,
                         record.career.name,
                         record.responsible], :style => normal
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
        sheet.add_row [self.human_attribute_name(:name),
                       self.human_attribute_name(:short_name),
                       self.human_attribute_name(:year),
                       self.human_attribute_name(:career),
                       self.human_attribute_name(:responsible)], :style => header, :widths => [30, 30, 30, 30, 30]
      end
    end
    return xlsx
  end

  # column order
  # 0-name 1-short_name 2-year 3-career 4-responsable
  def self.import_xls file=nil
    result = []

    counters = {:all => -1, :saved => 0, :not_saved => 0 }

    matter_list = Matter.all.collect{ |m| m.name }

    if file
      matters_file = Spreadsheet.open file.path
      matters = matters_file.worksheet 'Matters'
      1.upto matters.row_count do |row_index|
        counters[:all] += 1

        name = matters.row(row_index)[0]
        short_name = matters.row(row_index)[1]
        career_name = matters.row(row_index)[3]
        year = matters.row(row_index)[2]
        responsible = matters.row(row_index)[4]

        unless name.blank? || short_name.blank? || career_name.blank?
          name.strip!
          career_name.strip!

          career = Career.find_by_name career_name
          save = true
          if matter_list.include? name
            if career
              if career_name == career.name
                counters[:not_saved] += 1
                save = false
                result << I18n.t('activerecord.matter_import_info.duplicated', :name => name)
              end
            else
              # missing career
              counters[:not_saved] += 1
              result << I18n.t('activerecord.matter_import_info.missing_career', :name => name, :career => career_name)
              save = false
            end
          end

          if save
            matter = Matter.new :name => name, :short_name => short_name, :career_id => career.id, :year => year, :responsible => responsible
            if matter.save!
              counters[:saved] += 1
              result << I18n.t('activerecord.matter_import_info.saved', :name => name)
            else
              counters[:not_saved] += 1
              result << I18n.t('activerecord.matter_import_info.not_saved', :name => name)
            end
          end
        end
      end
    end
    if result.empty?
      result << I18n.t('activerecord.matter_import_info.empty')
    end
    result << I18n.t('activerecord.matter_import_info.finished')
    result << I18n.t('activerecord.matter_import_info.count', :all => counters[:all], :saved => counters[:saved], :not_saved => counters[:not_saved])
    return result
  end
end
