require 'spec_helper'

describe Metastore::Storage::Base do

  include FakeFS::SpecHelpers

  let(:contents) { false }
  let(:file) { Pathname.new('/fake_file.mixed') }

  subject { described_class.new(file) }

  before do
    File.open(file, 'w') { |f| f.write(contents) } if contents
  end

  describe '#contents' do
    context 'when file does not exist' do
      it 'returns an empty Hash' do
        expect(subject.contents).to eql({})
      end
    end

    context 'when file is empty' do
      let(:contents) { {}.to_yaml }

      it 'returns an empty Hash' do
        expect{ subject.contents }.to raise_error(NotImplementedError)
      end
    end

    context 'when file is not empty' do
      let(:contents) { { 'key' => 'value' }.to_yaml }

      it 'returns an empty Hash' do
        expect{ subject.contents }.to raise_error(NotImplementedError)
      end
    end
  end

  describe '#save!' do
    it 'saves the contents to file' do
      expect{ subject.save!({}) }.to raise_error(NotImplementedError)
    end
  end
end
