module ShellStrike
  class TaskResult
    def initialize(success_status, *messages)
      @success_status = success_status
      @messages = messages
    end

    def success?
      @success_status
    end

    def error_message
      @messages.reject_blank.join(' ')
    end
  end
end