#
# Configuration File Parser / Accessor
#
class CfgParser
    def initialize(cfg_file)
        @cfg_hash = {}   
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
                @cfg_hash[key] = val
            end
        end
    end
    
    def get_val(key)
        @cfg_hash[key]
    end
 end

# create parser object
cfg_parser = CfgParser.new('test.cfg')

# tests
p cfg_parser
p cfg_parser.get_val('log_file_path')
p cfg_parser.get_val('test_mode')