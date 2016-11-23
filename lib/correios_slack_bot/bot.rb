require "correios_slack_bot/correios"

module CorreiosSlackBot
  class Bot < SlackRubyBot::Bot
    match /^Pacote (?<pacote>\w*)$/ do |client, data, match|
      package_log = CorreiosSlackBot::Correios.new(match[:pacote]).package_log
      result = package_log.map do |log|
        {
          title: "#{log[:date]} - #{log[:origin]}",
          text: "#{log[:description]} (#{log[:status]})"
        }
      end
      client.web_client.chat_postMessage(
        channel: data.channel,
        as_user: true,
        attachments: result
      )
    end
  end
  # Bot.run
end
