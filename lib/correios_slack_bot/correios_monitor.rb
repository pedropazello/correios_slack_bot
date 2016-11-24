module CorreiosSlackBot
  class CorreiosMonitor
    attr_accessor :package_code, :known_package_log
    def initialize(package_code, options = {})
      @package_code = package_code
      @known_package_log = options[:from_package_log] || []
    end

    def last_change
      correios_package_log[0]
    end

    def package_log_changed?
      (correios_package_log - known_package_log).size > 0
    end

    def correios_package_log
      CorreiosSlackBot::Correios.new(package_code).package_log
    end
  end
end
