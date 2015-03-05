require 'spec_helper'

describe Metastore::Cabinet, memfs: true do

  include FakeFS::SpecHelpers

  let(:file) { '/fake_file.mixed' }
  let(:contents) { {}.send("to_#{storage_type}".to_sym) }

  subject { described_class.new(file, storage_type: storage_type) }

  before(:example) do
    File.open(file, 'w') { |f| f.write(contents) }
  end

  describe '#get' do
    let(:method_name) { :get }

    context 'for YAML' do
      let(:storage_type) { :yaml }
      include_examples 'a YAML Cabinet#get'
    end

    context 'for JSON' do
      let(:storage_type) { :json }
      include_examples 'a JSON Cabinet#get'
    end
  end

  describe '#[]' do
    let(:method_name) { :[] }

    context 'for YAML' do
      let(:storage_type) { :yaml }
      include_examples 'a YAML Cabinet#get'
    end

    context 'for JSON' do
      let(:storage_type) { :json }
      include_examples 'a JSON Cabinet#get'
    end
  end

  describe '#set' do
    let(:method_name) { :set }

    context 'for YAML' do
      let(:storage_type) { :yaml }
      include_examples 'a YAML Cabinet#set'
    end

    context 'for JSON' do
      let(:storage_type) { :json }
      include_examples 'a JSON Cabinet#set'
    end
  end

  describe '#[]=' do
    let(:method_name) { :[]= }

    context 'for YAML' do
      let(:storage_type) { :yaml }
      include_examples 'a YAML Cabinet#set'
    end

    context 'for JSON' do
      let(:storage_type) { :json }
      include_examples 'a JSON Cabinet#set'
    end
  end

  describe '#clear!' do
    let(:storage_type) { :yaml }
    let(:contents) { { 'key1' => 'key1.value' }.to_yaml }

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
