# frozen_string_literal: true
# Module that can be included (mixin) to take and output TSV data
module TsvBuddy
  require 'csv'

  TAB = "\t"
  TSV_OPTIONS = { col_sep: TAB }.freeze

  # take_tsv: converts a String with TSV data into @data
  # parameter: tsv - a String in TSV format
  def take_tsv(tsv)
    tsv_data = CSV.parse(tsv, TSV_OPTIONS)
    column_names = tsv_data.shift
    @data = tsv_data.map { |row| hashify(column_names, row) }
  end

  # to_tsv: converts @data into tsv string
  # returns: String in TSV format
  def to_tsv
    CSV.generate(TSV_OPTIONS) { |csv| dump(data: @data, to_file: csv) }
  end

  private

  def hashify(keys, values)
    keys.zip(values).to_h
  end

  def dump(data:, to_file:)
    to_file << keys = extract_keys(data)
    data.each { |record| to_file << sorted_values(record, using_keys: keys) }
  end

  def extract_keys(data)
    data.map(&:keys).flatten.uniq
  end

  def sorted_values(record, using_keys: keys)
    using_keys.map { |key| record[key] }
  end
end
