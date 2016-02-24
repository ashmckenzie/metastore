require 'spec_helper'

describe Metastore::StorageFactory do
  subject { described_class }

  describe '.from_sym' do
    context 'when a unknown storage type is provided' do
      it 'raises an exception' do
        expect{ subject.from_sym(:bleep) }.to raise_error(Metastore::Errors::UnknownStorageType)
      end
    end

    context 'when a known storage type is provided' do
      it 'returns the class' do
        expect(subject.from_sym(:yaml)).to eql(Metastore::Storage::YAML)
      end
    end
  end
end
