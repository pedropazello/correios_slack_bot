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
    end
  end
end
