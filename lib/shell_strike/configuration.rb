module ShellStrike
  module Configuration
    include DynamicAttributes
    
    dynamic_attributes :user_dictionary_path, :password_dictionary_path, :host_list_path
    dynamic_attributes :usernames, :passwords, :hosts

   
    def self.validate
      return ValidationResult.new(false, 'Either a user dictionary path or usernames must be supplied.') unless (username_dictionary_path_was_supplied? || usernames_exist?)

      return ValidationResult.new(false, 'Either a password dictionary path or passwords must be supplied.') unless (password_dictionary_path_was_supplied? || passwords_exist?)

      return ValidationResult.new(false, 'Either a host list path or hosts must be supplied.') unless (host_list_path_was_supplied? || hosts_exist?)

      ValidationResult.new(true, '')
    end

    private

    def self.usernames_exist?
      !array_is_empty_or_nil?(usernames)
    end
    
    def self.passwords_exist?
      !array_is_empty_or_nil?(passwords)
    end

    def self.hosts_exist?
      !array_is_empty_or_nil?(hosts)
    end

    def self.username_dictionary_path_was_supplied?
      path_exists? user_dictionary_path
    end

    def self.password_dictionary_path_was_supplied?
      path_exists? password_dictionary_path
    end

    def self.host_list_path_was_supplied?
      path_exists? host_list_path
    end
    
    def self.path_exists?(path)
      return false if path.nil?

      File.exists? path
    end

    def self.array_is_empty_or_nil?(arr)
      arr.nil? || arr.empty?
    end

  end
end