require "correios_slack_bot/correios"

module CorreiosSlackBot
  class Bot < SlackRubyBot::Bot
    match /^Pacote (?<pacote>\w*)$/ do |client, data, match|
      historico = CorreiosSlackBot::Correios.new(match[:pacote]).package_log
      result = historico.map do |registro|
        {
          title: "#{registro[:date]} - #{registro[:origin]}",
          text: "#{registro[:description]} (#{registro[:status]})"
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
