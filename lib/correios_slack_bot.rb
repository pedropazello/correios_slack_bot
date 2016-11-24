require "correios_slack_bot/version"
require "correios_slack_bot/correios"
require "slack-ruby-bot"

module CorreiosSlackBot
  class Bot < SlackRubyBot::Bot
    match /^exibe o pacote (?<package_code>\w*)$/ do |client, data, match|
      package_log = CorreiosSlackBot::Correios.new(match[:package_code]).package_log
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

    match /^rastreia o pacote (?<package_code>\w*)$/ do |client, data, match|
      package_log = CorreiosSlackBot::Correios.new(match[:package_code]).package_log
      known_package_log = package_log
      client.say(text: 'Blz, vou começar a rastrar, qualquer coisa te falo',
        channel: data.channel)
      loop do
        new_package_log = CorreiosSlackBot::Correios.new(match[:package_code]).package_log
        if (new_package_log - known_package_log).size > 0
          log = new_package_log[0]
          client.web_client.chat_postMessage(
            channel: data.channel,
            as_user: true,
            attachments: [
              {
                title: "#{log[:date]} - #{log[:origin]}",
                text: "#{log[:description]} (#{log[:status]})"
              }
            ]
          )
          known_package_log = new_package_log
        end
        sleep 30
      end
    end
  end
end
