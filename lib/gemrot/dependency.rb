require 'set'

# Gem dependency value object
class Dependency
  attr_reader :name, :current, :latest, :dep

  # name: Gem name
  # current: Gem version as defined in Gemfile
  # latest: Latest version of gem defined @ RubyGems
  def initialize(dep, latest)
    @dep      = dep                            # The gem
    @name     = dep.name                       # Gem name
    @latest   = latest                         # Latest Gem version
    req_s     = dep.requirement.as_list.last   # Gem version defined in Gemfile
    num_index = req_s.index(/\p{N}/)           # Find index of the first number in string
    @current  = req_s[num_index..req_s.length] # Pluck gem version number X.Y.Z
  end

  # Should it warn
  def should_warn?
    !is_latest? && !in_ignore_group?
  end

  # Is the current version the same as the latest
  def is_latest?
    current == latest
  end

  # Print gem information
  def to_s
    [
      "Name:    #{name}",
      "Current: #{current}",
      "Latest:  #{latest}"
    ].join("\n")
  end

  def in_ignore_group?
    [:development, :test].each { |env| return true if dep.groups.include?(env) }
    false
  end
end
