# frozen_string_literal: true

require 'qualys/version'

require 'spec_helper'

describe Qualys do
  it 'has a version' do
    expect(Qualys).to be_const_defined('VERSION')
  end
end
