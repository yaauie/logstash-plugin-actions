require "json"
require "rubygems"

# Each Action has an event passed to it.
=begin
event = JSON.parse(File.read(ENV['GITHUB_EVENT_PATH']))
puts "event inspect:"
puts event.inspect

puts "\n**printing environment"
puts ENV.inspect

puts "\nlisting files"
puts `ls`
=end
def find_pr_version
  gemspec_path = Dir.glob("*.gemspec").first
  spec = Gem::Specification::load(gemspec_path)
  spec.version.to_s
end

def fetch_git_versions
  `git tag -l`.split("\n").map {|version| version.tr("v", "").strip }
end

def find_version_changelog_entry(version)
  IO.read("CHANGELOG.md").match(/## #{version}\n\s+.+$/)
end

def compute_changelog_suggestion
  commits = `git log master.. --format=%B`.split("\n")
  commits.map {|commit| "  - #{commit}" }
end

pr_version = find_pr_version()
puts "Plugin version is this PR is: #{pr_version}"

published_versions = fetch_git_versions()

if published_versions.include?(pr_version)
  puts "Version #{pr_version} has already been published to Rubygems.org"
  puts "Please bump the version to speed up plugin publishing after this PR is merged"
  exit(1)
end

unless match = find_version_changelog_entry(pr_version)
  puts "We were unable to find a CHANGELOG.md entry for version #{pr_version}"
  puts "Please at a new entry to the top of CHANGELOG.md similar to:\n"
  puts "## #{pr_version}"
  puts compute_changelog_suggestion()
  exit(1)
else
  puts "Found changelog entry for version #{pr_version}:"
  puts match.to_s
end

puts "We're all set up for the version bump. Thank you!"
