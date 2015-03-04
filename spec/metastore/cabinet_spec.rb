require 'spec_helper'

describe Metastore::Cabinet, memfs: true do

  include FakeFS::SpecHelpers

  let(:file) { '/fake_file.yml' }
  let(:contents) { {} }

  subject { described_class.new(file) }

  before(:example) do
    File.open(file, 'w') { |f| f.write(contents.to_yaml) }
  end

  describe '#get' do
    let(:method_name) { :get }

    include_examples 'a Cabinet#get'
  end

  describe '#[]' do
    let(:method_name) { :[] }

    include_examples 'a Cabinet#get'
  end

  describe '#set' do
    let(:method_name) { :set }

    include_examples 'a Cabinet#set'
  end

  describe '#[]=' do
    let(:method_name) { :[]= }

    include_examples 'a Cabinet#set'
  end

  describe '#clear!' do
    let(:contents) { { 'key1' => 'key1.value' } }

    it 'clears out the file' do
      expect(File.read(file)).to eql("---\nkey1: key1.value\n")
      subject.clear!
      expect(File.read(file)).to eql("--- {}\n")
    end

    context 'when the file cannot be cleared' do
      before do
        expect(File).to receive(:open).with(file.to_s, 'w').and_raise(StandardError.new('Any exception'))
      end

      it 'returns true' do
        expect{ subject.clear! }.to raise_error(Metastore::Errors::CabinetCannotSet, 'Any exception')
      end
    end

    context 'when the file can be cleared' do
      it 'returns true' do
        expect(subject.clear!).to eql(true)
      end
    end
  end
end
