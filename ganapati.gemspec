$:.push File.expand_path("../lib", __FILE__)
#require "ganapati/version"
require "rake"

Gem::Specification.new do |s|
  s.name = "ganapati"
  s.version = "0.0.5"
  s.authors = ["Brian Muller"]
  s.date = %q{2011-02-10}
  s.description = "Hadoop HDFS Thrift interface for Ruby"
  s.summary = "Simple lib for interfaceing with Hadoop's distributed file system HDFS."
  s.email = "brian.muller@livingsocial.com"
  s.files = FileList["lib/**/*", "[A-Z]*", "Rakefile", "docs/**/*"]
  s.homepage = "https://github.com/livingsocial/ganapati"
  s.require_paths = ["lib"]
  s.bindir = "bin"
  s.executables << 'hdfs_thrift_server'
  s.executables << 'hls'
  s.executables << 'hcp'
  s.rubyforge_project = "ganapati"
  s.add_dependency('thrift', '>= 0.5.0')
  s.add_development_dependency('mocha', '>=0.10.0')
end
