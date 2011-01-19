module Ganapati
  
  class Client
    def initialize(server, port, timeout=60)
      socket = Thrift::Socket.new(server, port)
      @transport = Thrift::BufferedTransport.new(socket)
      @transport.open
      protocol = Thrift::BinaryProtocol.new(@transport)
      @client = ThriftHadoopFileSystem::Client.new(protocol)
      @client.setInactivityTimeoutPeriod(timeout)
    end

    def close
      @transport.close
    end

    # shutdown the thrift server
    def shutdown(status=0)
      @client.shutdown status
    end

    # copy local file to remote
    def put(localpath, destpath)
      create(destpath) { |dest|
        Kernel.open(localpath) { |source|
          # read 1 MB at a time
          while record = source.read(1048576)
            dest.write(record)
          end
        }
      }
    end

    # copy remote file to local
    def get(remotepath, destpath)
      Kernel.open(destpath, 'w') { |dest|
        open(remotepath) { |source|
          size = source.length
          index = 0
          while index < size
            dest.write(source.read(index, 1048576))
            index += 1048576
          end
        }
      }
    end

    # for writing to a new file
    def create(path, &block)
      file_handle :create, path, &block
    end

    # for reading
    def open(path, &block)
      file_handle :open, path, &block
    end

    # for appending
    def append(path, &block)
      file_handle :append, path, &block
    end
    
    def rm(path, recursive=false)
      @client.rm pname(path), recursive
    end

    def mv(source, dest)
      @client.rename pname(source), pname(dest)
    end

    def mkdir(path)
      @client.mkdirs pname(path)
    end

    def exists?(path)
      @client.exists pname(path)
    end

    def stat(path)
      @client.stat pname(path)
    end

    def ls(path, details=false)
      statuses = @client.listStatus pname(path)
      (details) ? statuses : statuses.map { |s| s.path }
    end

    def chmod(path, mode)
      @client.chmod pname(path), mode
    end

    def chown(path, owner, group)
      @client.chown pname(path), owner, group
    end

    def set_replication(path, level)
      @client.setReplication pname(path), level
    end

    def self.run(server, port)
      c = Client.new(server, port)
      result = yield c
      c.close
      result
    end

    private
    def file_handle(action, path)
      pathname = pname(path)
      fh = @client.send action, pathname
      result = f = HFile.new(@client, fh, pathname)
      if block_given?
        result = yield f
        f.close
      end
      result      
    end

    def pname(path)
      Pathname.new(:pathname => path.to_s)
    end
  end

end
