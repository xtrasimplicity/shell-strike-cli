require 'spec_helper'

describe ShellStrike::ValidationResult do
  describe '#valid??' do
    context 'when initialised with `false`' do
      let(:instance) { ShellStrike::ValidationResult.new(false, '') }
      subject { instance.valid? }

      it { is_expected.to be false }
    end

    context 'when initialised with `true`' do
      let(:instance) { ShellStrike::ValidationResult.new(true, '') }
      subject { instance.valid? }

      it { is_expected.to be true }
    end
  end

  describe '#error_message' do
    context 'when an array of messages is supplied on instantiation' do
      let(:array_of_messages) { ['message 1', 'message 2', 'message 3'] }
      let(:instance) { ShellStrike::ValidationResult.new(false, array_of_messages) }
      subject { instance.error_message }

      it 'returns the message as a string, concatenated with a blank space' do
        expect(subject).to eq(array_of_messages.join(' '))
      end
    end

    context 'when a string is supplied on instantiation' do
      let(:message) { 'This is a message!' }
      let(:instance) { ShellStrike::ValidationResult.new(false, message) }
      subject { instance.error_message }

      it { is_expected.to eq(message) }
    end
  end
end