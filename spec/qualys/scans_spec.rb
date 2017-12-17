# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Qualys::Scans, type: :model do
  let(:scans) { Qualys::Scans.all }

  describe '#all' do
    it 'gets all the scans' do
      VCR.use_cassette('scans') do
        expect(scans.size).to eq 5
        expect(scans).to all(be_an(Qualys::Scan))
      end
    end

    it 'does not return scan if there is no' do
      VCR.use_cassette('emptyscans') do
        expect(scans).to eq []
      end
    end
  end

  describe '#get' do
    it 'gets the scan' do
      VCR.use_cassette('get') do
        details = Qualys::Scans.get('scan/1512633883.79354')
        expect(details.first.keys).to include('ip', 'dns', 'netbios', 'qid', 'instance',
                                              'protocol', 'port', 'ssl', 'fqdn')
      end
    end
  end
end

RSpec.describe Qualys::Scan, type: :model do
  let(:scan) { Qualys::Scans.all[1] }
  let(:error_scan) { Qualys::Scans.all[0] }

  describe '#initialize' do
    it 'has all fields filled' do
      VCR.use_cassette('scan') do
        expect(scan.ref).to eq 'scan/1512633883.79354'
        expect(scan.title).to eq 'shellshock 20171207'
        expect(scan.type).to eq 'On-Demand'
        expect(scan.date).to eq '2017-12-07T08:04:43Z'
        expect(scan.duration).to eq '00:07:02'
        expect(scan.status).to eq 'Finished'
        expect(scan.target).to eq '47.69.112.62'
        expect(scan.user).to eq 'thomas'
      end
    end
  end

  describe '#details' do
    it 'returns the details' do
      VCR.use_cassette('scan') do
        VCR.use_cassette('get') do
          expect(scan.details.first.keys).to include('ip', 'dns', 'netbios', 'qid', 'instance',
                                                     'protocol', 'port', 'ssl', 'fqdn')
        end
      end
    end
  end

  describe '#finished' do
    it 'returns returns a bolean' do
      VCR.use_cassette('scan') do
        expect(scan.finished?).to be true
      end

      VCR.use_cassette('scan') do
        expect(error_scan.finished?).to be false
      end
    end
  end
end
