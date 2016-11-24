require "correios_slack_bot/version"
require "correios_slack_bot/correios"
require "correios_slack_bot/correios_monitor"
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
      client.say(text: 'Beleza, qualquer coisa te falo!', channel: data.channel)
      monitor = CorreiosSlackBot::CorreiosMonitor.new(match[:package_code])
      loop do
        sleep 30
        last_change = monitor.last_change

        if monitor.package_log_changed?
          monitor.known_package_log = monitor.correios_package_log
          client.web_client.chat_postMessage(
            channel: data.channel,
            as_user: true,
            attachments: [
              title: "Nova atualização : #{last_change[:date]} - #{last_change[:origin]}",
              text: "#{last_change[:description]} (#{last_change[:status]})"
            ]
          )
        end
      end
    end
  end
end
