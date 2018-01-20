class ShellStrike::Host
  attr_reader :host, :port, :connection_timeout
  
  def initialize(host, port = 22, connection_timeout = 30)
    @host = host
    @port = port
    @connection_timeout = connection_timeout
  end

  def reachable?
    begin
      Socket.tcp(@host, @port, connect_timeout: @connection_timeout) { |s| s.close }
      return true
    rescue
      return false  
    end
  end

  def validate_credentials(username, password)
    valid = false
    message = ''

    begin
      Net::SSH.start(@host, username, password: password, port: @port, non_interactive: true, timeout: @connection_timeout)

      valid = true
    rescue Net::SSH::AuthenticationFailed
      message = 'Invalid Credentials'
    rescue Net::SSH::ConnectionTimeout
      message = "Connection timed out whilst attempting to connect to #{@host} on port #{@port}"
    rescue Net::SSH::Exception => e
      message = "An unexpected error occurred whilst connecting to #{@host} on port #{@port} with username #{username} and password #{@password}: #{e.message}"
    rescue Errno::EHOSTUNREACH => e
      message = "Unable to connect to #{@host}: #{e.message}"
    end

    ShellStrike::TaskResult.new(valid, message)
  end
end