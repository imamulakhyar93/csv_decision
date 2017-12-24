# frozen_string_literal: true

# CSV Decision: CSV based Ruby decision tables.
# Created December 2017 by Brett Vickers
# See LICENSE and README.md for details.
module CSVDecision
  # Methods to assign a matcher to data cells
  module Matchers
    # rubocop: disable Lint/BooleanSymbol
    NON_NUMERIC_CONSTANTS = {
      true: true,
      false:  false,
      nil: nil
    }.freeze
    # rubocop: enable Lint/BooleanSymbol

    # Match cell against a function call or symbolic expression.
    class Function < Matcher
      # Looks like a function call or symbol expressions, e.g.,
      # == true
      # := function(arg: symbol)
      # == :column_name
      FUNCTION_CALL =
        "(?<operator>=|:=|==|=|<|>|!=|>=|<=|:|!\\s*:)\\s*" \
        "(?<negate>!?)\\s*" \
        "(?<name>#{Header::COLUMN_NAME}|:)(?<args>.*)"

      FUNCTION_RE = Matchers.regexp(FUNCTION_CALL)

      def initialize(options = {})
        @options = options
      end

      def matches?(cell)
        match = Expression::FUNCTION.match(cell)
        return false unless match

        # Check if the guard condition is a cell constant
        proc = Constant.match?(match)
        return proc if proc

        Expression.function?(match: match, cell: cell)
      end
    end
  end
end