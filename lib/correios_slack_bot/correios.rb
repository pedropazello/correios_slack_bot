require 'httparty'
require 'correios_slack_bot/correios_scraper'

module CorreiosSlackBot
  class Correios
    BASE_URL = "http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&"
    def initialize(package_code)
      @package_code = package_code
    end

    def package_log
      correios_scraper.parsed_package_log
    end

    private

    def correios_scraper
      @correios_scraper ||= CorreiosScraper.new(correios_response)
    end

    def correios_response
      HTTParty.get("#{BASE_URL}P_COD_UNI=#{@package_code}")
    end
  end
end
