require File.expand_path('../../spec_helper', __FILE__)

describe Array do
  describe '#reject_blank' do
    let(:arr) { ['', ' ', 'test', :abc, nil] }
    subject { arr.reject_blank }

    it 'removes strings with nothing but whitespace' do
      expect(subject).not_to include ' '
    end

    it 'removes `nil`' do
      expect(subject).not_to include nil
    end

    it 'retains the other values' do
      expect(subject).to eq ['test', :abc]
    end
  end
end