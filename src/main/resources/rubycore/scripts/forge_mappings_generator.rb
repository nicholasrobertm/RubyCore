
require 'csv'
require 'optparse'

class MappingsGenerator
  def initialize(class_name, mappings_path = '.', output_path = '.')
    clazz = Object.const_get(class_name)

    fields = CSV.read("#{mappings_path}/fields.csv", headers: true)
    methods = CSV.read("#{mappings_path}/methods.csv", headers: true)

    parsed_fields = []
    parsed_methods = []

    unfiltered_methods = clazz.methods(false)
    unfiltered_instance_methods = clazz.instance_methods(false)

    unfiltered_methods.each do |method|
      if fields.select{|field| field["searge"] == method}
         field_hash = fields.find{|field| field["searge"] == method.to_s}
         field_hash = field_hash.to_hash if field_hash
         if field_hash.is_a? Hash
           next if field_hash.empty?
           parsed_fields << "#{field_hash['name']}=#{field_hash['searge']}"
         end
      end

      if methods.select{|met| met["searge"] == method}
         method_hash = methods.find{|met| met["searge"] == method.to_s}
         method_hash = method_hash.to_hash if method_hash
         if method_hash.is_a? Hash
           next if method_hash.empty?
           next unless clazz.method(method)
           next if method_hash['name'].include?('access')
           parameter_size = clazz.method(method.to_sym).arity
           parameter_string = ""
           if parameter_size > 0
            parameter_string += '('
            parameter_size.times do |p|
              if p == parameter_size - 1
                parameter_string += "arg#{p}"
              else
                parameter_string += "arg#{p},"
              end
            end
            parameter_string += ')'
           end
           parsed_methods << "def #{method_hash['name'].underscore}#{parameter_string}\n    #{method_hash['searge']}#{parameter_string}\n  end"
         end
      end

    end

    unfiltered_instance_methods.each do |method|
          if fields.select{|field| field["searge"] == method}
             field_hash = fields.find{|field| field["searge"] == method.to_s}
             field_hash = field_hash.to_hash if field_hash
             if field_hash.is_a? Hash
               next if field_hash.empty?
               parsed_fields << "#{field_hash['name']}=#{field_hash['searge']}"
             end
          end

          if methods.select{|met| met["searge"] == method}
             method_hash = methods.find{|met| met["searge"] == method.to_s}
             method_hash = method_hash.to_hash if method_hash
             if method_hash.is_a? Hash
               next if method_hash.empty?
               next unless clazz.instance_method(method)
               next if method_hash['name'].include?('access')
               parameter_size = clazz.instance_method(method.to_sym).arity
               parameter_string = ""
               if parameter_size > 0
                parameter_string += '('
                parameter_size.times do |p|
                  if p == parameter_size - 1
                    parameter_string += "arg#{p}"
                  else
                    parameter_string += "arg#{p},"
                  end
                end
                parameter_string += ')'
               end
               parsed_methods << "def #{method_hash['name'].underscore}#{parameter_string}\n    #{method_hash['searge']}#{parameter_string}\n  end"
             end
          end

        end


    File.open("#{output_path}/#{class_name.split('::')[0].downcase}.rb", 'w+') do |file|
        file.write "class #{class_name}\n"
        parsed_fields.each do |field|
          file.write "  #{field}\n\n"
        end
        parsed_methods.each do |method|
          file.write "  #{method}\n\n"
        end
        file.write 'end'
    end
  end
end



