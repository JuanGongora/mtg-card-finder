# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mtg_card_finder/version.rb'

Gem::Specification.new do |spec|
  spec.name          = "mtg-card-finder"
  spec.version       = MTGCardFinder::VERSION
  spec.authors       = ["Juan Gongora"]
  spec.email         = ["gongora.animations@gmail.com"]

  spec.summary       = %q{Daily market analyzer for MTG cards}
  spec.description   = %q{Find the highest rising/falling card prices on the MTG open market}
  spec.homepage      = "https://github.com/JuanGongora/mtg-card-finder"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   << "mtg-card-finder"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "pry", "~> 0.10.4"
  spec.add_dependency "rubysl-open-uri", "~> 2.0"
  spec.add_dependency "nokogiri", "~> 1.7.1"
  spec.add_dependency "tco", "~> 0.1.8"
  spec.add_dependency "sqlite3", "~> 1.3.13"
  spec.add_dependency "mechanize", "~> 2.7.5"
  spec.add_dependency "require_all", "~> 1.4"
end
