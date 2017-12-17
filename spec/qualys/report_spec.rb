# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Qualys::Report, type: :model do
  let(:report) { Qualys::Report.global_report }

  describe '#templates' do
    it 'gets all the templates' do
      VCR.use_cassette('templates') do
        expect(Qualys::Report.templates.first['ID']).to eq '91078694'
      end
    end
  end

  describe '#find_by_id' do
    it 'loads the report' do
      VCR.use_cassette('templates') do
        VCR.use_cassette('load_global_report') do
          expect(Qualys::Report.find_by_id(4_888_430)).to be_kind_of Qualys::Report
        end
      end
    end

    it 'returns nil when the report does not exist ' do
      VCR.use_cassette('templates') do
        VCR.use_cassette('try_load_not_existing_report') do
          expect(Qualys::Report.find_by_id(4_888_480)).to be_nil
        end
      end
    end
  end

  describe '#create_global_report' do
    it 'gets the report id' do
      VCR.use_cassette('templates') do
        VCR.use_cassette('create_global_report') do
          expect(Qualys::Report.create_global_report).to eq '4888438'
        end
      end
    end
  end

  describe '#global_report' do
    it 'loads the report' do
      VCR.use_cassette('templates') do
        VCR.use_cassette('global_report') do
          stub_const('Qualys::Report::TIMEOUT', 0)
          expect(Qualys::Report.global_report).to be_kind_of(Qualys::Report)
        end
      end
    end
  end

  describe '#hosts' do
    it 'gets all the host' do
      VCR.use_cassette('templates') do
        VCR.use_cassette('global_report') do
          stub_const('Qualys::Report::TIMEOUT', 0)
          expect(report.hosts).to all(be_kind_of(Qualys::Host))
        end
      end
    end
  end
end
