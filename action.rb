require "json"
require "rubygems"

# Each Action has an event passed to it.
event = JSON.parse(File.read(ENV['GITHUB_EVENT_PATH']))
puts "event inspect:"
puts event.inspect

puts "\n**printing environment"
puts ENV.inspect

puts "\nlisting files"
puts `ls`
def find_pr_version
  gemspec_path = Dir.glob("*.gemspec").first
  spec = Gem::Specification::load(gemspec_path)
  spec.version
end

pr_version = find_pr_version()
puts "Plugin version is this PR is: #{pr_version}"

published_versions = `git tag -l`.split("\n").map {|version| version.tr("v", "") }

if published_versions.include?(pr_version)
  puts "This version has already been published to Rubygems.org"
  puts "Please bump the version to speed up plugin publishing after this PR is merged"
  exit(1)
end

if IO.read("CHANGELOG.md").match(/## #{pr_version}\n\s+.+$/)
  puts "We were unable to find a CHANGELOG.md entry for version #{pr_version}"
  puts "Please at a new entry to the top of CHANGELOG.md similar to:\n"
  puts "## #{pr_version}"
  puts "  - text"
  exit(1)
end
