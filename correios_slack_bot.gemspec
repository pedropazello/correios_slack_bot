# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'correios_slack_bot/version'

Gem::Specification.new do |spec|
  spec.name          = "correios_slack_bot"
  spec.version       = CorreiosSlackBot::VERSION
  spec.authors       = ["Pedro Pazello"]
  spec.email         = ["pedropazello.rj@gmail.com"]

  spec.summary       = %q{
    Slack integration with Correios package log web site. Search for a package log and alert when
    this package is waiting for you.
  }
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/pedropazello/correios_slack_bot"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["correios_slack_bot"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.1"
  spec.add_development_dependency "pry", "~> 0.10.4"
  spec.add_dependency "httparty", "~> 0.14.0"
  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_dependency "slack-ruby-bot", "~> 0.9.0"
  spec.add_dependency "celluloid-io", "~> 0.17.3"
  spec.add_dependency "daemons", "~> 1.2"
end
