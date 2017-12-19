# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Qualys::Report, type: :model do
  let(:report) { Qualys::Report.create }
  let(:scan_ref) { Qualys::Scans.all[1].ref }
  let(:hosts_list) { Qualys::Scans.all[1].hosts }
  let(:scan_report) { Qualys::Report.create(hosts_list) }

  describe '#templates' do
    it 'gets all the templates' do
      VCR.use_cassette('templates') do
        expect(Qualys::Report.templates.first['ID']).to eq '91078694'
      end
    end
  end

  describe '#fetch' do
    it 'loads the report' do
      VCR.use_cassette('templates') do
        VCR.use_cassette('load_global_report') do
          expect(Qualys::Report.fetch(4_888_430)).to be_kind_of Qualys::Report
        end
      end
    end

    it 'returns nil when the report does not exist ' do
      VCR.use_cassette('templates') do
        VCR.use_cassette('try_load_not_existing_report') do
          expect(Qualys::Report.fetch(4_888_480)).to be_nil
        end
      end
    end
  end

  describe '#launch' do
    it 'gets the report id' do
      VCR.use_cassette('templates') do
        VCR.use_cassette('create_global_report') do
          expect(Qualys::Report.launch).to eq '4888438'
        end
      end
    end
  end

  describe '#create' do
    it 'loads the report' do
      VCR.use_cassette('templates') do
        VCR.use_cassette('global_report') do
          stub_const('Qualys::Report::TIMEOUT', 0)
          expect(Qualys::Report.create).to be_kind_of(Qualys::Report)
        end
      end
    end

    it 'loads the report for a scan' do
      VCR.use_cassette('scan') do
        VCR.use_cassette('get') do
          @ref = Qualys::Scans.all[1].ref
        end
      end

      VCR.use_cassette('templates') do
        VCR.use_cassette('scan') do
          VCR.use_cassette('get') do
            VCR.use_cassette('launch_scan_report') do
              VCR.use_cassette('fetch_scan_report') do
                stub_const('Qualys::Report::TIMEOUT', 0)
                expect(Qualys::Report.create(@ref)).to be_kind_of(Qualys::Report)
              end
            end
          end
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

  describe '#create_by_scan' do
    it 'gets all the host' do
      VCR.use_cassette('scan') do
        VCR.use_cassette('get') do
          VCR.use_cassette('templates') do
            VCR.use_cassette('scan_report') do
              expect(Qualys::Report.launch(hosts_list)).to eq '4927942'
            end
          end
        end
      end
    end
  end
end
