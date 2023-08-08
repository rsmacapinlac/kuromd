# frozen_string_literal: true

require 'kuromd'
require 'kuromd/version'

RSpec.describe Kuromd do
  it 'has a version number' do
    expect(Kuromd::VERSION).not_to be nil
  end
  it 'has a logger' do
    expect(Kuromd.logger).to be_a Logger
  end
end
