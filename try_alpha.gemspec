# frozen_string_literal: true

require_relative 'lib/try_alpha/version'

Gem::Specification.new do |spec|
  spec.name = 'try_alpha'
  spec.version = TryAlpha::VERSION
  spec.authors = ['Lucas Pesqueira', 'André Rodrigues', 'Maurício Lima', 'Caio Mello']
  spec.email = ['pesqueira.lucas@gmail.com', 'andrerpbts@gmail.com', 'mauriciopdvg@gmail.com',
                'caio-mello94@hotmail.com']

  spec.summary = 'TryTechLabs Alpha toolbelt'
  spec.description = 'TryTechLabs Alpha toolbelt is a collection of tools to help you install ' \
                     'and manage your project'
  spec.homepage = 'https://github.com/trytechlabs/try_alpha'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "#{spec.homepage}/gems/try_alpha"
  spec.metadata['changelog_uri'] = "#{spec.homepage}/gems/try_alpha/CHANGELOG.md"

  spec.files = `git ls-files -- lib/*`.split("\n")
  spec.files += %w[README.md LICENSE.md Changelog.md .yardopts .document]
  spec.bindir = 'exe'
  spec.executables = `git ls-files -- exe/*`.split("\n").map { |f| File.basename(f) }
  spec.rdoc_options = ['--charset=UTF-8']
  spec.require_path = 'lib'

  spec.add_dependency 'activesupport', '>= 6.0'
  spec.add_dependency 'http', '>= 4.4', '< 6.0'
  spec.add_dependency 'thor', '~> 1.3.2'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
