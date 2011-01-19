require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc "Create documentation"
Rake::RDocTask.new("doc") { |rdoc|
  rdoc.title = "Ganapati - Hadoop HDFS thrift interface for Ruby"
  rdoc.rdoc_dir = 'docs'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
}

desc "Re-generate thrift files"
task "regen_thrift" do 
  if ENV['HADOOP_HOME'].nil?
    puts "You must set your HADOOP_HOME variable before calling this task."
    return
  end
  system "thrift --gen rb -o /tmp #{ENV['HADOOP_HOME']}src/contrib/thriftfs/if/hadoopfs.thrift"
  system "mv /tmp/gen-rb/* lib/thrift"
end

spec = Gem::Specification.new do |s|
  s.name = "ganapati"
  s.version = "0.0.1"
  s.authors = ["Brian Muller"]
  s.date = %q{2011-01-19}
  s.description = "Hadoop HDFS Thrift interface for Ruby"
  s.summary = "Simple lib for interfaceing with Hadoop's distributed file system HDFS."
  s.email = "brian.muller@livingsocial.com"
  s.files = FileList["lib/**/*"]
  s.homepage = "https://github.com/livingsocial/ganapati"
  s.require_paths = ["lib"]
  s.bindir = "bin"
  s.executables << 'hdfs_thrift_server'
  s.rubygems_version = "1.3.5"
  s.add_dependency('thrift', '>= 0.5.0')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

desc "Default task: builds gem"
task :default => [ :gem, :doc ]
