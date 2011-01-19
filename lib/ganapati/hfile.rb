module Ganapati
  
  class HFile
    def initialize(client, handle, pathname)
      @client = client
      @handle = handle
      @pathname = pathname
    end

    def write(data)
      call :write, data
    end

    def read(offset=0, size=nil)
      size ||= stat.length
      call :read, offset, size
    end

    def close
      call :close
    end

    def stat
      @client.stat(@pathname)
    end

    def length
      stat.length
    end

    private
    def call(method, *args)
      @client.send method, @handle, *args
    end  
  end

end
