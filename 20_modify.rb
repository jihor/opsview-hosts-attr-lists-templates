#!/usr/bin/env ruby
require 'json'
require 'find'

class Modifier

  def initialize
    @json_ext = '.json'
    @export_dir = './export'
    @modified_dir = './modified'
    @attr_lists_dir = './attr_lists'

    @host_attributes = 'hostattributes'
    @attr_lists = begin
      result = {}
      Dir["#{@attr_lists_dir}/*.json"].each { |file|
        result[File.basename(file, @json_ext)] = JSON.parse(File.read(file))
      }
      result
    end
  end

  def modify(mask, hosts_configs)
    Dir["#{@export_dir}/#{mask}#{@json_ext}"].sort.each { |file|
      hostname = File.basename(file, @json_ext)
      next unless hosts_configs.key? hostname
      config = JSON.parse(File.read(file))
      config[@host_attributes] = []
      lists = []
      hosts_configs[hostname].each { |list_name|
        lists << list_name
        config[@host_attributes] << @attr_lists[list_name]
      }
      puts "Modified #{hostname} to have attributes from lists: #{lists.join(', ')}"
      config[@host_attributes].flatten!(1)
      Dir.mkdir(@modified_dir) unless Dir.exist?(@modified_dir)
      File.write("#{@modified_dir}/#{hostname}#{@json_ext}", JSON.pretty_generate(config))
    }
  end
end

default_attr_lists = ['service_a_jmx', 'service_b_jmx', 'disk', 'service_wsdl']
disk_only = ['disk']
Modifier::new.modify('prodhost-*', {'prodhost-01' => default_attr_lists,
                                    'prodhost-02' => default_attr_lists,
                                    'prodhost-03' => disk_only})
puts 'Done'