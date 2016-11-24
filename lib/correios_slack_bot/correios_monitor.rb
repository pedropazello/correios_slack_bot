module CorreiosSlackBot
  class CorreiosMonitor
    attr_reader :package_code, :known_package_log
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

    def monitor(when_change:, when_not_change:)
      if package_log_changed?
        when_change.call
      else
        when_not_change.call
      end
    end

    private

    def correios_package_log
      CorreiosSlackBot::Correios.new(package_code).package_log
    end
  end
end
