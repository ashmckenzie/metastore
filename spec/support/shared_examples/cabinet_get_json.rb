shared_examples 'a JSON Cabinet#get' do

  context 'when the file is empty' do
    it 'returns nil' do
      expect(subject.public_send(method_name, 'key1')).to be_nil
    end
  end

  context 'when the file is not empty' do
    context 'with a single key' do
      let(:contents) { { 'key1' => 'key1.value' }.to_json }

      context 'and key2 does not exist' do
        it 'returns nil' do
          expect(subject.public_send(method_name, 'key2')).to be_nil
        end
      end

      context 'and key1 exists' do
        it 'returns value' do
          expect(subject.public_send(method_name, 'key1')).to eql('key1.value')
        end
      end
    end

    context 'with a multi key' do
      let(:contents) { { 'key1' => { 'key1' => 'key1.key1.value' } }.to_json }

      context 'and key2.key2 does not exist' do
        it 'returns nil' do
          expect(subject.public_send(method_name, 'key2.key2')).to be_nil
        end
      end

      context 'and key1.key1 exists' do
        it 'returns value' do
          expect(subject.public_send(method_name, 'key1.key1')).to eql('key1.key1.value')
        end
      end
    end
  end
end
