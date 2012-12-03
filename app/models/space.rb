class Space < ActiveRecord::Base
  attr_accessible :name, :short_name, :description, :capacity, :space_type_id,
                  :events, :event_ids, :space_type

  belongs_to :space_type

  has_many :events

  validates :name, :presence => true
  validates :short_name, :presence => true
  validates :space_type, :presence => true

  def rical_events
    events = []
    self.events.each do |event|
      events << event.to_rical
    end
    return events
  end

  def rical_occurrences options={}
    until_date = options[:before] || Date.today + 5.years
    after_date = options[:after] || Date.new
    occurrences = []
    if options[:overlapping]
      self.events.each do |event|
        occurrences << event.to_rical.occurrences(:overlapping =>[after_date, until_date])
      end
    else
      self.events.each do |event|
        occurrences << event.to_rical.occurrences(:starting => after_date, :before => until_date)
      end
    end

    return occurrences.flatten
  end

  def self.free_spaces options={}
    until_date = options[:before] || Date.today + 5.years
    after_date = options[:after] || Date.new
    Space.all.select{|s| s.rical_occurrences(:before => until_date, :after => after_date, :overlapping => options[:overlapping]).empty? }
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
                       self.human_attribute_name(:space_type),
                       self.human_attribute_name(:short_name),
                       self.human_attribute_name(:capacity),
                       self.human_attribute_name(:description)], :style => header, :widths => [30, 30, 30, 30, 50]
        records.each do |record|
          sheet.add_row [record.name,
                         record.space_type.name,
                         record.short_name,
                         record.capacity,
                         record.description], :style => normal
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
                       self.human_attribute_name(:space_type) + ' (*)',
                       self.human_attribute_name(:short_name) + ' (*)',
                       self.human_attribute_name(:capacity),
                       self.human_attribute_name(:description)], :style => header, :widths => [30, 30, 30, 30, 50]
      end
    end
    return xlsx
  end

  # column order
  # 0-name 1-space_type_name 2-short_name 3-capacity 4-description
  def self.import_xls file=nil
    result = []
    if file
      spaces_file = Spreadsheet.open file.path
      spaces = spaces_file.worksheet self.model_name.human
      counters = { :all => -1, :saved => 0, :not_saved => 0 }
      1.upto spaces.row_count do |row_index|
        counters[:all] += 1
        unless spaces.row(row_index)[0].blank? || spaces.row(row_index)[1].blank? || spaces.row(row_index)[2].blank?
          space = Space.find_by_name spaces.row(row_index)[0].strip


          unless space
            space_type = SpaceType.find_by_name spaces.row(row_index)[1].strip
            if space_type

              space = Space.new :name => spaces.row(row_index)[0],
                                :space_type => space_type,
                                :short_name => spaces.row(row_index)[2],
                                :capacity => spaces.row(row_index)[3],
                                :description => spaces.row(row_index)[4]

              if space.save!
                result << I18n.t('activerecord.space_import_info.saved', :name => spaces.row(row_index)[0])
                counters[:saved] += 1
              else
                result << I18n.t('activerecord.space_import_info.not_saved', :name => spaces.row(row_index)[0])
                counters[:not_saved] += 1
              end

            else
              result << I18n.t('activerecord.space_import_info.missing_type', :name => spaces.row(row_index)[0], :space_type => spaces.row(row_index)[1])
              counters[:not_saved] += 1
            end

          else
            result << I18n.t('activerecord.space_import_info.duplicated', :name => spaces.row(row_index)[0])
            counters[:not_saved] += 1
          end

        end
      end
    end
    if result.empty?
      result << I18n.t('activerecord.space_import_info.empty')
    end
    result << I18n.t('activerecord.space_import_info.finished')
    result << I18n.t('activerecord.space_import_info.count', :all => counters[:all], :saved => counters[:saved], :not_saved => counters[:not_saved])
    return result
  end

  def self.with_no_events_count
    self.all.select{ |space| space.event_ids.empty? }.size
  end

  def self.with_events_count
    self.all.select{ |space| !space.event_ids.empty? }.size
  end

end
