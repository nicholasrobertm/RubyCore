# frozen_string_literal: true

require 'java'

require 'rubycore/common'
require 'rubycore/patches/string'
require 'rubycore/gems'
RubyCore::Gems.process_gems([{ rubygem: 'rubyzip', as: 'zip' }])

require 'rubycore/api'
require 'rubycore/forge/forge'
require 'rubycore/paths'


module RubyCore
  # Used to load in all the ruby mods

  class Loader
    def initialize
      @@mods = []
    end

    def self.add_mod(mod = nil, name = nil, version = nil)
      puts "Adding mod #{name}"
      if mod && name && version
        @@mods << mod
      else
        puts 'You need to define a mod class a name and the version of the mod![mod not loaded]'
      end
    end

    def loader_init
      puts 'Loader INIT'
      @path = RubyCore::Paths.new
      @gems_folder = @path.gems_folder
      @ruby_mods_folder = @path.ruby_mods_folder
      @mods_folder = @path.forge_mods_folder
      @cache_folder = @path.cache_folder
      @mods = []

      # run_generators # Should be commented out with the require above when built. Just a hack for generating mappings


      Zip.on_exists_proc = true # We need to rebuild the cache folder every time in case a mod updates, setting this makes extracting allowed to overwrite
      create_base
      load_mods
      initialize_mods
      puts 'RubyCore Loader loaded'
    end

    def create_base
      # Creating the paths
      @path.create(@path.rubycore_folder)
      @path.create(@path.ruby_mods_folder)
      @path.create(@path.gems_folder)
      @path.create(@path.cache_folder)
    end

    def load_mods

      puts RubyCoreApi::MOD_ID
      # We only wanna load external mods if the mod ID is still rubycore. If the developer modifies the mod ID the functionality below this is disabled.
      return unless RubyCoreApi::MOD_ID == 'rubycore'

      jar_mods = []
      puts 'Loading external mods into cache'
      Dir[File.join(@mods_folder, '*.jar')].each do |m|
        if m.include? 'rubycore'
          Zip::File.open(m) do |zip_file|
            zip_file.each do |entry|
              next unless entry.to_s.include?('.rb')
              next unless entry.to_s.include?('mod_')
              FileUtils.mkdir_p(File.dirname(File.absolute_path(@cache_folder + '/rubycore/' + entry.to_s.split('/')[-1])))
              entry.extract(@cache_folder + '/rubycore/' + entry.to_s.split('/')[-1])
              # Iterate on them later and load in each one.
            end
          end
        else
          puts "Loading mod #{m} into cache"
          Zip::File.open(m) do |zip_file|
            zip_file.each do |entry|
              next unless entry.to_s.include?('.rb')
              jar_mods << zip_file.to_s unless jar_mods.include? zip_file.to_s
              # Iterate on them later and load in each one.
            end
          end
        end
      end

      jar_mods.each do |file|
        extract_zip(file, @cache_folder + "/#{File.basename(file.to_s.split('/')[-1], '.jar')}")
      end

      puts "Loading mods from cache"
      puts Dir[@cache_folder + '/*']
      Dir[@cache_folder + '/*'].each do |m|
        puts "Loading mod #{m} from cache"
        Dir[File.join(m, 'mod_*.rb')].each do |mod|
          load mod
        end
      end

      puts "Loading ruby scripts"
      Dir[File.join(@ruby_mods_folder, 'mod_*.rb')].each do |mod|
        load mod
      end

    end

    def initialize_mods
      puts 'Initializing mods...'
      puts @@mods
      @@mods.each do |mod|
        puts "Initializing mod #{mod}"
        @mods << mod.new
      end
    end

    def call_method(name, args = nil)
      @mods.each_with_index do |mod, index|
        if args
          mod.send(name.to_s, args) if @@mods[index].method_defined? name
        elsif @@mods[index].method_defined? name
          mod.send(name.to_s)
        end
      end
    end

    # We use this to create a 'cache' that can be loaded by rubycore.
    # TODO: Find a way around unzipping these
    def extract_zip(file, destination)
      FileUtils.mkdir_p(destination)

      Zip::File.open(file) do |zip_file|
        zip_file.each do |f|
          fpath = File.join(destination, f.name)
          zip_file.extract(f, fpath)
        end
      end
    end

    def process_event(event)
        call_method('process_event', event)
    end

    # Temporary hack to Generate Method / Variable class mapping. Will go away after 1.17 when everything no longer has to use internal map names.
    # Only ran when needed locally then manually copied to src/main/resources
    def run_generators
      @generator = MappingsGenerator.new('AbstractBlock::Properties',  @path.cache_folder + '/rubycore/scripts', @path.cache_folder + '/output')
      @generator = MappingsGenerator.new('Material',  @path.cache_folder + '/rubycore/scripts', @path.cache_folder + '/output')
      @generator = MappingsGenerator.new('Item::Properties',  @path.cache_folder + '/rubycore/scripts', @path.cache_folder + '/output')
      @generator = MappingsGenerator.new('ItemGroup',  @path.cache_folder + '/rubycore/scripts', @path.cache_folder + '/output')
    end

  end
end

RubyCore::Loader
