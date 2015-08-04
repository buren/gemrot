require 'rubygems_api'
require 'gemnasium/parser'

require 'gemrot/dependency'
require 'gemrot/dependencies'

module Gemrot
  class Runner
    attr_reader :gemfile, :dependencies, :rubygems

    GemfileParser  = ::Gemnasium::Parser::Gemfile
    RubyGemsClient = ::Rubygems::API::Client

    def initialize(gemfile)
      @gemfile      = GemfileParser.new(gemfile)
      @dependencies = @gemfile.dependencies
      @rubygems     = RubyGemsClient.new
    end

    def find_dependencies
      gem_deps = Dependencies.new

      dependencies.each do |gem_dep|
        dependency = build_dependency(gem_dep)
        gem_deps.add(dependency)
        yield(dependency) if dependency.should_warn?
      end
      gem_deps
    end

    def build_dependency(dependency)
      latest = latest_version_of(dependency)
      Dependency.new(dependency, latest)
    end

    def latest_version_of(dependency)
      rubygems.gem_info(dependency.name).body['version']
    end
  end
end
