# frozen_string_literal: true

# CSV Decision: CSV based Ruby decision tables.
# Created December 2017 by Brett Vickers
# See LICENSE and README.md for details.
module CSVDecision
  class Error < StandardError; end
  class CellValidationError < Error; end
  class FileError < Error; end

  # Parse the input data which may either be a file, CSV string or array of arrays
  def self.parse(input, options = {})
    Parse.table(table: CSVDecision::Table.new,
                input: input,
                options: Options.normalize(options))
  end

  # Parse the CSV file and create a new decision table object
  module Parse
    def self.table(table:, input:, options:)
      # In most cases the decision table will be loaded from a CSV file.
      table.file = input if Data.input_file?(input)

      # Parse input data into an array of arrays
      table.rows = Data.to_array(data: input)

      # Pick up any options specified in the CSV file before the header row.
      # These override any options passed as parameters to the parse method.
      table.options = Options.from_csv(table: table, attributes: options).freeze

      # Parse the header row
      table.columns = Header.parse(table: table)

      Parse.data(table)
    rescue CSVDecision::Error => exp
      raise exp unless table.file
      message = "error processing CSV file #{table.file}\n#{exp.inspect}"
      raise CSVDecision::FileError, message
    end

    def self.data(table)
      matchers = nil
      # matchers = Matchers.new(table.options)

      data_rows(table)

      table.freeze
    end

    def self.data_rows(table)
      table.matchers = matchers(table.options).freeze

      index = 0
      while index < table.rows.count
        row = table.rows[index]
        parse_inputs(table: table, row: row, index: index)
        # parse_outputs(row, index)

        index += 1
      end

      table.columns.freeze
    end

    def self.matchers(options)
      options[:matchers].collect { |klass| klass.new(options: options) }
    end

    # Parse input columns
    def self.parse_inputs(table:, row:, index:)
      table.columns.ins.each_pair do |col, entry|
        cell = row[col]
        # type, value = matchers.scan(cell: cell, column: entry)
      end
    end
  end
end