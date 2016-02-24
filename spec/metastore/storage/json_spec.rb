require 'spec_helper'

describe Metastore::Storage::JSON do

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
      let(:contents) { {}.to_json }

      it 'returns an empty Hash' do
        expect(subject.contents).to eql({})
      end
    end

    context 'when file is not empty' do
      let(:contents) { { 'key' => 'value' }.to_json }

      it 'returns a Hash' do
        expect(subject.contents).to eql({ "key" => "value" })
      end
    end
  end

  describe '#save!' do
    let(:values) { {} }

    before do
      subject.save!(values)
    end

    context 'when values is empty' do
      it 'saves the contents to file' do
        expect(file.read).to eql('{}')
      end
    end

    context 'when values are not empty' do
      context 'when there are symbols in the values' do
        let(:values) { { symbol: :symbol } }

        it 'saves the contents to file' do
          expect(file.read).to eql('{"symbol":"symbol"}')
        end
      end

      context 'when the values are complex' do
        let(:values) {
          {
            "array"                 => [],
            "hash"                  => {},
            "nested_hash_in_array"  => [ {} ],
            "nested_arrays_in_hash" => { "array" => [] }
          }
        }

        it 'saves the contents to file' do
          expect(file.read).to eql('{"array":[],"hash":{},"nested_hash_in_array":[{}],"nested_arrays_in_hash":{"array":[]}}')
        end
      end
    end
  end
end
