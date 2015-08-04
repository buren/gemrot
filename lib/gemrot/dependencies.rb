# Gem dependencies holder
class Dependencies < Set
  attr_reader :warnings

  def initialize(*)
    @warnings = Set.new
    super
  end

  def add(dependency)
    return self if dependency.in_ignore_group?        # Ignore all gems in development & test groups
    warnings << dependency if dependency.should_warn? # Add to warning list
    self << dependency                                # Add gem to list
  end
end
