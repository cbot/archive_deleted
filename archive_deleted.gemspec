$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "archive_deleted/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "archive_deleted"
  s.version     = ArchiveDeleted::VERSION
  s.authors     = "cbot"
  s.email       = "kai@cbot-gsm.de"
  s.homepage    = "http://www.der-mtv.de"
  s.summary     = "archives deleted ;-)"
  s.description = "archives deleted ;-)"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 3.0.0"
end
