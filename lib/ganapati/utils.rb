module Ganapati
  class FileUrl
    attr_reader :scheme, :host, :port, :path

    def initialize(url, default_scheme='yourmom', default_host='localhost', default_port=8118)
      @url = url
      if @url.start_with? 'file://' or (not @url.start_with? 'hdfs://' and default_scheme == :file)
        parse_file_scheme
      else
        parse_hdfs_scheme(default_host, default_port)
      end
    end

    def to_s
      @url
    end

    def hdfs?
      @scheme == :hdfs
    end

    def local?
      @scheme == :file
    end

    private
    def parse_file_scheme
      @scheme = :file
      @path = @url.slice(7, @url.length-7)
    end

    def parse_hdfs_scheme(default_host, default_port)
      @scheme = :hdfs
      @path = @url.start_with?('hdfs://') ? @url.slice(7, @url.length-7) : @url
      if @path.start_with? '/'
        @host = default_host
        @port = default_port.to_i
      else
        parts = @path.split('/')
        hostport = parts.shift.split(':')
        @host = hostport.first
        @port = (hostport.length == 2) ? hostport.last.to_i : default_port.to_i
        @path = '/' + parts.join('/')
      end        
    end
  end
end
