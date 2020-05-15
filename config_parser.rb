#
# Configuration File Parser / Accessor
#

# ConfigParser
class ConfigParser
  @config = {}

  def initialize(cfg_file)
    @config = init_config(cfg_file)
  end

  def get(key)
    @config[key]
  end

  def all
    @config
  end

  private

  def init_config(cfg_file)
    config = {}
    
    File.foreach(cfg_file) do |line|
      line = line.lstrip.chomp
      if line.chr != '#' && line.include?('=')
        kv = line.split('=', 2)
        key = kv[0].strip
        val = kv[1].strip
        # convert string val to appropriate type
        if %w[on yes true].include?(val.downcase)
          val = true
        elsif %w[off no flase].include?(val.downcase)
          val = false
        elsif Integer(val, exception: false)
          val = val.to_i
        elsif Float(val, exception: false)
          val = val.to_f
        end
        # add hash kv for current line
        config[key] = val
      end
    end

    config
  end
end

# create parser object
cfg_parser = ConfigParser.new('test.cfg')

# sample calls
p cfg_parser.all.length
p cfg_parser.get('log_file_path')
p cfg_parser.get('test_mode')

# unit testing
require 'minitest/autorun'

class TestConfigParser < MiniTest::Test
  def setup
    @cfg_parser = ConfigParser.new('test.cfg')
  end

  def test_has_nine
    assert_equal 9, @cfg_parser.all.length
  end

  def test_returns_string
    assert_equal '/tmp/logfile.log', @cfg_parser.get('log_file_path')
  end

  def test_returns_bool_true
    assert @cfg_parser.get('test_mode')
  end

  def test_returns_bool_false
    refute @cfg_parser.get('debug_mode')
  end

  def test_returns_int
    assert @cfg_parser.get('server_id').is_a? Integer
  end

  def test_returns_float
    assert @cfg_parser.get('server_load_alarm').is_a? Float
  end
end