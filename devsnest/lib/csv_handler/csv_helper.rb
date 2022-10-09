class CsvHelper

  def initialize(records, fields:, **options)
    @records = records
    @options = options
    @fields = fields
  end

  def call
    CSV.generate(**@options) do |csv|
      csv << @fields
      @records.each do |rec|
        csv << rec.attributes.values_at(*@fields)
      end
    end
  end
end