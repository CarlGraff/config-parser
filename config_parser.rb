#
# Configuration File Parser / Accessor
#

class ConfigParser
    @cfg_hash = {}   

    def initialize(cfg_file)
        @cfg_hash = init_hash(cfg_file)    
    end

    def get(key)
        @cfg_hash[key]
    end

    def all
        @cfg_hash
    end

    private

    def init_hash(cfg_file)
        cfg_hash = {}
        File.foreach(cfg_file) do |line|
            line = line.lstrip.chomp
            if line.chr != '#' && line.include?('=')
                kv = line.split('=',2)
                key = kv[0].strip
                val = kv[1].strip
                # convert string val to appropriate type
                case
                    when ['on', 'yes', 'true'].include?(val.downcase)
                        val = true
                    when ['off', 'no', 'flase'].include?(val.downcase)
                        val = false
                    when Integer(val, exception: false)
                        val = val.to_i
                    when Float(val, exception: false)
                        val = val.to_f
                end
                # add hash kv for current line
                cfg_hash[key] = val
            end
        end
        cfg_hash
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
    assert_equal "/tmp/logfile.log", @cfg_parser.get('log_file_path')
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

