require 'nokogiri'

module CorreiosSlackBot
  class CorreiosScraper
    def initialize(correios_package_log_page)
      @doc = Nokogiri::HTML(correios_package_log_page)
    end

    def parsed_package_log
      package_log_lines.map.with_index do |line, index|
        next if only_status_line?(line)
        {
          date: find_date(line),
          origin: find_origin(line),
          status: find_status(line),
          description: find_description(index)
        }
      end.compact
    end

    private

    def package_log_lines
      @doc.xpath('//table//tr').drop(1)
    end

    def only_status_line?(line)
      line.children[1].nil?
    end

    def find_date(line)
      line.children[0].text
    end

    def find_origin(line)
      line.children[1].text
    end

    def find_status(line)
      line.children[2].text
    end

    def find_description(current_index)
      find_current_line_description(current_index)&.children&.text
    end

    def find_current_line_description(current_index)
      package_log_lines[current_index + 1]
    end
  end
end
