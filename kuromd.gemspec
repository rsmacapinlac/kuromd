# frozen_string_literal: true

require_relative 'lib/kuromd/version'

Gem::Specification.new do |spec|
  spec.name = 'kuromd'
  spec.version = Kuromd::VERSION
  spec.authors = ['Ritchie Macapinlac']
  spec.email = ['ritchie@macapinlac.com']

  spec.summary = 'These are my personal productivity scripts.'
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = 'https://www.macapinlac.com'
  spec.required_ruby_version = '>= 3.2.2'

  # spec.metadata['allowed_push_host'] = 'TODO: Set to your gem server \'https://example.com\''

  spec.metadata['homepage_uri'] = spec.homepage
  spec.licenses                 = ['MIT']
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'rspec'

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'activesupport', '~> 7.0.6'
  spec.add_dependency 'commander', '~> 4.6.0'
  spec.add_dependency 'dates_from_string', '~> 0.9.7'
  spec.add_dependency 'dotenv', '~> 2.8.1'
  spec.add_dependency 'faraday', '~> 2.7.10'
  spec.add_dependency 'ruby_matter', '~> 0.9.8'
  spec.add_dependency 'terminal-table', '~> 3.0.2'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
