require 'gemrot/version'
require 'gemrot/runner'

module Gemrot
  def self.run
    puts "Running. This may take a while.. \n\n"

    gemfile = File.read('Gemfile')

    dependencies = Runner.new(gemfile).find_dependencies do |out_of_date_gem|
      puts "#{out_of_date_gem.to_s}\n\n"
    end

    if dependencies.empty?
      puts "Congrats! No out of date gems found! All #{dependencies.length} are up to date :)"
    else
      puts "\n"
      puts "[WARNING] #{dependencies.warnings.length}/#{dependencies.length} gems are of out of date!"
    end
  end
end
