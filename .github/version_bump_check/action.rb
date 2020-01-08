require "json"

# Each Action has an event passed to it.
event = JSON.parse(File.read(ENV['GITHUB_EVENT_PATH']))
puts "event inspect:"
puts event.inspect

puts "\n**printing environment"
puts ENV.inspect

puts "\nlisting files"
puts `ls`

require "rubygems"

gemspec_path = Dir.glob("*.gemspec").first
spec = Gem::Specification::load(gemspec_path)

puts "Current version is #{spec.version}"
