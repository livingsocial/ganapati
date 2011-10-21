require "test_helper"

class ClientTest < Test::Unit::TestCase
  def stub_thrift!
    @socket = stub_everything("socket")
    Thrift::Socket.stubs(:new).returns(stub)

    @transport = stub_everything("transport")
    Thrift::BufferedTransport.stubs(:new).returns(@transport)

    @protocol = stub_everything("protocol")
    Thrift::BinaryProtocol.stubs(:new).returns(@protocol)

    @client = stub_everything("client")
    ThriftHadoopFileSystem::Client.stubs(:new).returns(@client)
  end

  def setup
    stub_thrift!
  end

  def test_readlines_with_one_chunk
    ganapati = Ganapati::Client.new("127.0.0.1", 1234)
    ganapati.stubs(:readchunks).yields("abc123")

    lines = []
    ganapati.readlines("/foo") { |line| lines << line }

    assert_equal ["abc123"], lines
  end

  def test_readlines_with_two_chunks
    ganapati = Ganapati::Client.new("127.0.0.1", 1234)
    ganapati.stubs(:readchunks).multiple_yields(["abc\n123"], ["456"])

    lines = []
    ganapati.readlines("/foo") { |line| lines << line }

    assert_equal ["abc", "123456"], lines
  end

  def test_readlines_with_chunks_with_multiple_lines
    ganapati = Ganapati::Client.new("127.0.0.1", 1234)
    ganapati.stubs(:readchunks).multiple_yields(["abc\n123\n456\n"], ["789"])

    lines = []
    ganapati.readlines("/foo") { |line| lines << line }

    assert_equal ["abc", "123", "456", "789"], lines
  end

  def test_readlines_with_middle_chunk
    ganapati = Ganapati::Client.new("127.0.0.1", 1234)
    ganapati.stubs(:readchunks).multiple_yields(["abc\n123"], ["456"], ["789"])

    lines = []
    ganapati.readlines("/foo") { |line| lines << line }

    assert_equal ["abc", "123456789"], lines
  end

  def test_readlines_with_sep_character_at_the_end_of_chunks
    ganapati = Ganapati::Client.new("127.0.0.1", 1234)
    ganapati.stubs(:readchunks).multiple_yields(["abc\n"], ["123\n"], ["456\n"])

    lines = []
    ganapati.readlines("/foo") { |line| lines << line }

    assert_equal ["abc", "123", "456"], lines
  end
end
