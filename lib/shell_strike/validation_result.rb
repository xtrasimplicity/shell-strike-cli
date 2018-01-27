module ShellStrike
  class ValidationResult < ResultObject::Base
    def initialize(is_valid, *messages)
      super
    end
    
    def valid?
      boolean_status
    end
  end
end