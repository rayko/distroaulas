module Exporter
  def to_xlsx options={} # Expects :attributes => [:attr1, :attr2 ...]
    attributes = options[:attributes]
    records = self.all
    xlsx = Axlsx::Package.new

    xlsx.workbook do |wb|
      styles = wb.styles

      header = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER, :bg_color => '4b7399', :fg_color => 'FF', :b => true, :alignment => {:horizontal => :center})
      normal = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER)

      wb.add_worksheet(:name => self.human_name) do |sheet|
        row_data = []
        attributes.each do |attr|
          row_data << self.human_attribute_name(attr)
        end
        sheet.add_row row_data, :style => header, :widths => [30]
        records.each do |record|
          row_data = attributes.collect{ |attr| record.send(attr) }
          sheet.add_row row_data, :style => normal
        end

      end
    end
    return xlsx
  end
end
