require File.expand_path('../spec_helper', __FILE__)

describe ShellStrike::Host do
  describe '#new' do
    let(:host_address) { '192.168.1.1' }
    let(:port) { '2222' }
    let(:connection_timeout) { 30 }
    subject { ShellStrike::Host.new(host_address, port, connection_timeout) }

    it 'sets the `host` attribute' do
      expect(subject.host).to eq(host_address)
    end

    it 'sets the `port` attribute' do
      expect(subject.port).to eq(port)
    end

    it 'sets the `connection_timeout` attribute' do
      expect(subject.connection_timeout).to eq(connection_timeout)
    end

    context 'when a port is not defined' do
      subject { ShellStrike::Host.new(host_address) }

      it 'sets the `port` attribute to `22`' do
        expect(subject.port).to eq(22)
      end
    end

    context 'when a `connection timeout` is not defined' do
      subject { ShellStrike::Host.new(host_address) }

      it 'sets the `connection timeout` attribute to `30` seconds' do
        expect(subject.connection_timeout).to eq(30)
      end
    end
  end

  describe '#reachable?' do
    let(:host) { ShellStrike::Host.new('192.168.1.1') }
    subject { host.reachable? }

    context 'when the host is unreachable' do
      before { allow(Socket).to receive(:tcp).and_raise(Errno::EHOSTUNREACH) }
      
      it { is_expected.to eq(false) }
    end

    context 'when the connection times out' do
      before { allow(Socket).to receive(:tcp).and_raise(Errno::ETIMEDOUT) }
     
      it { is_expected.to eq(false) }
    end

    context 'when the connection is successful' do
      before { allow(Socket).to receive(:tcp).and_return(true) }
     
      it { is_expected.to eq(true) }
    end
  end

  describe '#validate_credentials' do
    let(:host) { ShellStrike::Host.new('192.168.1.1') }
    let(:username) { 'admin' }
    let(:password) { 'thisIsAFakePassword' }

    context 'when the credentials are valid' do
      before { allow(Net::SSH).to receive(:start).and_return(true) }
      subject { host.validate_credentials(username, password) }

      describe '#valid?' do
        it 'should return true' do
          expect(subject.valid?).to eq(true)
        end
      end

      describe '#error_message' do
        it 'should not be set' do
          expect(subject.error_message.empty?).to be(true)
        end
      end
    end

    context 'when the credentials are invalid' do
      before { allow(Net::SSH).to receive(:start).and_raise(Net::SSH::AuthenticationFailed) }
      subject { host.validate_credentials(username, password) }

      describe '#valid?' do
        it 'should return false' do
          expect(subject.valid?).to eq(false)
        end
      end

      describe '#error_message' do
        it 'should be set' do
          expect(subject.error_message.empty?).to be(false)
        end
      end
    end

    context 'when the host is unreachable' do
      before { allow(Net::SSH).to receive(:start).and_raise(Errno::EHOSTUNREACH) }
      subject { host.validate_credentials(username, password) }

      describe '#valid?' do
        it 'should return false' do
          expect(subject.valid?).to eq(false)
        end
      end

      describe '#error_message' do
        it 'should be set' do
          expect(subject.error_message).to match(/no route to host/i)
        end
      end
    end

    context 'when the connection times out' do
      before { allow(Net::SSH).to receive(:start).and_raise(Net::SSH::ConnectionTimeout) }
      subject { host.validate_credentials(username, password) }

      describe '#valid?' do
        it 'should return false' do
          expect(subject.valid?).to eq(false)
        end
      end

      describe '#error_message' do
        it 'should be set' do
          expect(subject.error_message).to match(/connection timed out/i)
        end
      end
    end

    context 'when an unexpected SSH error occurs' do
      before { allow(Net::SSH).to receive(:start).and_raise(Net::SSH::Exception) }
      subject { host.validate_credentials(username, password) }

      describe '#valid?' do
        it 'should return false' do
          expect(subject.valid?).to eq(false)
        end
      end

      describe '#error_message' do
        it 'should be set' do
          expect(subject.error_message).to match(/unexpected error occurred/i)
        end
      end
    end
  end
end