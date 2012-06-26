class Space < ActiveRecord::Base
  attr_accessible :name, :short_name, :description, :capacity, :space_type_id,
                  :events, :event_ids, :space_type

  belongs_to :space_type

  has_many :events

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
      1.upto spaces.row_count do |row_index|
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
                result << "#{spaces.row(row_index)[0]}... Saved!"
              else
                result << "#{spaces.row(row_index)[0]}... Failed to save!"
              end

            else
              result << "#{spaces.row(row_index)[0]}... Missing Space Type: #{spaces.row(row_index)[1]}. Ignored."
            end

          else
            result << "#{spaces.row(row_index)[0]}... Already exists. Ignored."
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
