require 'httparty'
require 'nokogiri'

module CorreiosSlackBot
  class Correios
    BASE_URL = "http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&"
    def initialize(package_code)
      @package_code = package_code
    end

    def package_log
      values = []
      response = HTTParty.get("#{BASE_URL}P_COD_UNI=#{@package_code}")
      doc = Nokogiri::HTML(response)
        doc.xpath('//table//tr').drop(1).each_with_index do |tr, index|
        next if tr.children[1].nil?
        line = {}
        line[:date] = tr.children[0].text
        line[:origin] = tr.children[1].text
        line[:status] = tr.children[2].text
        line[:description] = doc.xpath('//table//tr').drop(1)[index + 1].children.text if doc.xpath('//table//tr').drop(1)[index + 1]
        values << line
      end
      values
    end
  end
end
