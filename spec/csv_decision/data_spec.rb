# frozen_string_literal: true
require_relative '../../lib/csv_decision'

describe CSVDecision::Data do
  it 'parses an CSV string' do
    result = CSVDecision::Data.to_array(data: '')
    expect(result).to be_a Array
    expect(result.empty?).to eq true
  end

  it 'parses an array' do
    result = CSVDecision::Data.to_array(data: [[]])
    expect(result).to eq []

    data = [
      ['#header', "R\u00E9sum\u00E9", '# comments'],
      ['IN :input', ' OUT :output  ', nil],
      ['input', '# comment', nil]
    ]
    result = CSVDecision::Data.to_array(data: data)
    expect(result).to eq [['IN :input', 'OUT :output', ''], ['input', '', '']]
  end

  it 'parses a CSV file' do
    file = Pathname(File.join(CSVDecision.root, 'spec/data/valid', 'empty.csv'))
    result = CSVDecision::Data.to_array(data: file)
    expect(result).to be_a Array
    expect(result.empty?).to eq true

    file = Pathname(File.join(CSVDecision.root, 'spec/data/valid', 'valid.csv'))
    result = CSVDecision::Data.to_array(data: file)
    expect(result).to be_a Array
    expect(result).to eq [['IN :input', 'OUT :output'], ['input', '']]
  end

  it 'raises an error for invalid input' do
    expect { CSVDecision::Data.to_array(data: {}) }
      .to raise_error(ArgumentError,
                      'Hash input invalid; ' \
                      'input must be a file path name, CSV string or array of arrays')
  end
end