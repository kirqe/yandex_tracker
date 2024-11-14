# frozen_string_literal: true

require_relative "lib/yandex_tracker/version"

Gem::Specification.new do |spec|
  spec.name = "yandex_tracker"
  spec.version = YandexTracker::VERSION
  spec.authors = ["kirqe"]
  spec.email = ["kirqe@yahoo.com"]

  spec.summary = "Ruby API wrapper for Yandex Tracker"
  spec.description = "A Ruby library for interacting with the Yandex Tracker API"
  spec.homepage = "https://github.com/kirqe/yandex_tracker"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-multipart", "~> 1.0"
end
