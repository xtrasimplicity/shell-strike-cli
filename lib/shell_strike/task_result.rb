module ShellStrike
  class TaskResult < ResultObject::Base
    def initialize(was_successful, *messages)
      super
    end

    def success?
      boolean_status
    end
  end
end