require 'spec_helper'

describe ShellStrike::Configuration do
  
  it { is_expected.to have_getter_and_setter_methods_for :user_dictionary_path }
  it { is_expected.to have_getter_and_setter_methods_for :password_dictionary_path }
  it { is_expected.to have_getter_and_setter_methods_for :host_list_path }
  it { is_expected.to have_getter_and_setter_methods_for :usernames }
  it { is_expected.to have_getter_and_setter_methods_for :passwords }
  it { is_expected.to have_getter_and_setter_methods_for :hosts }

  describe '#validate' do
    let(:example_usernames) { ['admin', 'root', 'administrator'] }
    let(:example_passwords) { ['password', 'drowssap'] }
    let(:example_hosts) { [ShellStrike::Host.new('192.168.1.2')] }

    before(:each) do
      # Set the defaults, so that we can simply override specific attributes in each test, rather than having to re-build the desired state from scratch.
      ShellStrike::Configuration.user_dictionary_path = '/path/to/user_dictionary_file'
      ShellStrike::Configuration.usernames = example_usernames
      ShellStrike::Configuration.password_dictionary_path = '/path/to/password_dictionary_file'
      ShellStrike::Configuration.passwords = example_passwords
      ShellStrike::Configuration.host_list_path = '/path/to/host_list_file'
      ShellStrike::Configuration.hosts = example_hosts
    end

    describe 'when a `user dictionary path` is specified, but `usernames` aren\'t' do
      before do
        ShellStrike::Configuration.user_dictionary_path = '/path/to/user_dictionary.txt'
        ShellStrike::Configuration.usernames = nil

        # Stub File.exists? so that it returns true
        allow(File).to receive(:exists?).and_return(true)
      end

      subject { ShellStrike::Configuration.validate }

      it { is_expected.to return_a_ValidationResult_object.with_a_validation_value_of(true) }
    end

    describe 'when `usernames` are specified, but a `user dictionary path` is not' do
      before do
        ShellStrike::Configuration.user_dictionary_path = 'a'
        ShellStrike::Configuration.usernames = example_usernames
      end

      subject { ShellStrike::Configuration.validate }

      it { is_expected.to return_a_ValidationResult_object.with_a_validation_value_of(true) }
    end

    describe 'when neither a `user dictionary path` nor `usernames` are specified' do
      before do
        ShellStrike::Configuration.user_dictionary_path = nil
        ShellStrike::Configuration.usernames = nil
      end
      subject { ShellStrike::Configuration.validate }

      it { is_expected.to return_a_ValidationResult_object.with_a_validation_value_of(false).and_a_message_matching(/either a user dictionary path or usernames must be supplied/i) }
    end

    describe 'when a `password dictionary path` is specified, but `passwords` aren\'t' do
      before do
        ShellStrike::Configuration.usernames = example_usernames
        ShellStrike::Configuration.password_dictionary_path = '/path/to/password_dictionary.txt'

        # Stub File.exists? so that it returns true
        allow(File).to receive(:exists?).and_return(true)
      end

      subject { ShellStrike::Configuration.validate }

      it { is_expected.to return_a_ValidationResult_object.with_a_validation_value_of(true) }
    end

    describe 'when `passwords` are specified, but a `password dictionary path` is not' do
      before do
        ShellStrike::Configuration.usernames = example_usernames
        ShellStrike::Configuration.password_dictionary_path = nil
        ShellStrike::Configuration.passwords = example_passwords

        # Stub File.exists? so that it returns true
        allow(File).to receive(:exists?).and_return(true)
      end

      subject { ShellStrike::Configuration.validate }

      it { is_expected.to return_a_ValidationResult_object.with_a_validation_value_of(true) }
    end

    describe 'when neither a `password dictionary path` nor `passwords` are specified' do
      before do
        ShellStrike::Configuration.usernames = example_usernames
        ShellStrike::Configuration.password_dictionary_path = nil
        ShellStrike::Configuration.passwords = nil
      end
      subject { ShellStrike::Configuration.validate }

      it { is_expected.to return_a_ValidationResult_object.with_a_validation_value_of(false).and_a_message_matching(/either a password dictionary path or passwords must be supplied/i) }
    end

    describe 'when a `host list path` is specified, but `hosts` aren\'t' do
      before do
        ShellStrike::Configuration.host_list_path = '/path/to/host_list.txt'
        ShellStrike::Configuration.hosts = nil

        # Stub File.exists? so that it returns true
        allow(File).to receive(:exists?).and_return(true)
      end

      subject { ShellStrike::Configuration.validate }

      it { is_expected.to return_a_ValidationResult_object.with_a_validation_value_of(true) }
    end

    describe 'when `hosts` are specified, but a `host list path` is not' do
      before do
        ShellStrike::Configuration.host_list_path = nil
        ShellStrike::Configuration.hosts = example_hosts
      end

      subject { ShellStrike::Configuration.validate }

      it { is_expected.to return_a_ValidationResult_object.with_a_validation_value_of(true) }
    end

    describe 'when neither a `host list path` nor `hosts` are specified' do
      before do
        ShellStrike::Configuration.host_list_path = nil
        ShellStrike::Configuration.hosts = nil
      end
      subject { ShellStrike::Configuration.validate }

      it { is_expected.to return_a_ValidationResult_object.with_a_validation_value_of(false).and_a_message_matching(/either a host list path or hosts must be supplied/i) }
    end
  end

end