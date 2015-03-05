shared_examples 'a JSON Cabinet#set' do

  it 'supports writing Hash values' do
    subject.public_send(method_name, :key1, { key2: 'value' })
    expect(File.read(file)).to eql(%q({"key1":{"key2":"value"}}))
  end

  it 'supports writing Array values' do
    subject.public_send(method_name, :key1, [ 'value' ])
    expect(File.read(file)).to eql(%q({"key1":["value"]}))
  end

  it 'turns symbol keys and values into strings' do
    subject.public_send(method_name, :key1, :key1_value)
    expect(File.read(file)).to eql(%q({"key1":"key1_value"}))
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
      expect(File.read(file)).to eql(%q({"key1":"key1.value"}))
    end
  end

  context 'when the file is not empty' do
    context 'and key1 does not exist' do
      let(:contents) { { 'key2' => 'key2.value' }.to_json }

      it 'writes out the key and value' do
        subject.public_send(method_name, 'key1', 'key1.value')
        expect(File.read(file)).to eql(%q({"key2":"key2.value","key1":"key1.value"}))
      end
    end

    context 'and key1 already exists' do
      context 'and we overwrite with a simple value' do
        let(:contents) { { 'key1' => 'key1.value' }.to_json }

        it 'overwrites the value' do
          subject.public_send(method_name, 'key1', 'key1.value.new')
          expect(File.read(file)).to eql(%q({"key1":"key1.value.new"}))
        end
      end

      context 'and we overwrite with a nestted value' do
        let(:contents) { { 'key1' => 'key1.value' }.to_json }

        it 'overwrites the value' do
          subject.public_send(method_name, 'key1.key1.key1', 'key1.key1.key1.value')
          expect(File.read(file)).to eql(%q({"key1":{"key1":{"key1":"key1.key1.key1.value"}}}))
        end
      end
    end
  end

end
