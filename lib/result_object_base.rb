module ResultObject
  class Base
    def initialize(boolean_status, *messages)
      @boolean_status = boolean_status
      @messages = messages
    end

    def error_message
      @messages.reject_blank.join(' ')
    end

    def boolean_status
      @boolean_status
    end
  end
end