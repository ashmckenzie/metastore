shared_examples 'a YAML Cabinet#set' do

  it 'supports writing Hash values' do
    subject.public_send(method_name, :key1, { key2: 'value' })
    expect(File.read(file)).to eql("---\nkey1:\n  key2: value\n")
  end

  it 'supports writing Array values' do
    subject.public_send(method_name, :key1, [ 'value' ])
    expect(File.read(file)).to eql("---\nkey1:\n- value\n")
  end

  it 'turns symbol keys and values into strings' do
    subject.public_send(method_name, :key1, :key1_value)
    expect(File.read(file)).to eql("---\nkey1: key1_value\n")
  end

  context 'when the value cannot be set/saved' do
    before do
      expect(File).to receive(:open).with(file.to_s, 'w').and_raise(StandardError.new('Any exception'))
    end

    it 'returns true' do
      expect{ subject.public_send(method_name, 'key1', 'key1.value') }.to raise_error(Metastore::Errors::CabinetCannotSet, 'Any exception')
    end
  end

  context 'when the value can be set/saved' do
    it 'returns true' do
      expect(subject.public_send(method_name, 'key1', 'key1.value')).to eql(true)
    end
  end

  context 'when the file is empty' do
    it 'writes out the key and value' do
      subject.public_send(method_name, 'key1', 'key1.value')
      expect(File.read(file)).to eql("---\nkey1: key1.value\n")
    end
  end

  context 'when the file is not empty' do
    context 'and key1 does not exist' do
      let(:contents) { { 'key2' => 'key2.value' }.to_yaml }

      it 'writes out the key and value' do
        subject.public_send(method_name, 'key1', 'key1.value')
        expect(File.read(file)).to eql("---\nkey2: key2.value\nkey1: key1.value\n")
      end
    end

    context 'and key1 already exists' do
      context 'and we overwrite with a simple value' do
        let(:contents) { { 'key1' => 'key1.value' }.to_yaml }

        it 'overwrites the value' do
          subject.public_send(method_name, 'key1', 'key1.value.new')
          expect(File.read(file)).to eql("---\nkey1: key1.value.new\n")
        end
      end

      context 'and we overwrite with a nestted value' do
        let(:contents) { { 'key1' => 'key1.value' }.to_yaml }

        it 'overwrites the value' do
          subject.public_send(method_name, 'key1.key1.key1', 'key1.key1.key1.value')
          subject.public_send(method_name, 'key2/key2/key2', 'key2.key2.key2.value')
          expect(File.read(file)).to eql("---\nkey1:\n  key1:\n    key1: key1.key1.key1.value\nkey2:\n  key2:\n    key2: key2.key2.key2.value\n")
        end
      end
    end
  end

end
