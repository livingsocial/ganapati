require 'ganapati/client'
require 'ganapati/hfile'

$:.unshift File.join(File.dirname(__FILE__), 'thrift')
require 'thrift_hadoop_file_system'
require 'hadoopfs_constants'

