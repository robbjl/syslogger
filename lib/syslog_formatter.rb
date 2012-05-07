# Adds some default information to syslog messages.
# Log format:
#   [Time.mSec] [SeverityLabel]: message

class Logger::SyslogFormatter < Logger::Formatter
  attr_accessor :datetime_format

  def initialize
    @datetime_format = nil
  end

  def call(severity, time, progname, msg)
    "#{severity.ljust(6)}: #{format_datetime(time)} - #{msg}\n"
  end

  protected

  def format_datetime(time)
    if @datetime_format.nil?
      milli = "%03d" % ((time.to_f - time.to_i) * 1000).round
      "#{time.strftime("%Y-%m-%d %H:%M:%S.#{milli}")}"
    else
      time.strftime(@datetime_format)
    end
  end

  def msg2str(msg)
    case msg
    when ::String
      msg
    when ::Exception
      "#{ msg.message } (#{ msg.class })\n" <<
        (msg.backtrace || []).join("\n")
    else
      msg.inspect
    end
  end
   
end