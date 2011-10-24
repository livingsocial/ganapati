require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Bundler::GemHelper.install_tasks

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

task :default => [ :gem, :doc ]






