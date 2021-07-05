# frozen_string_literal: true

$mods = []

require 'java'

require 'forge'
require 'rubycore/paths'
require 'rubycore/gems'
require 'rubycore/forge/registry'
require 'rubycore/forge/ore_block'

def add_mod(mod = nil, name = nil, version = nil)
  if mod && name && version
    $mods << mod
  else
    puts 'You need to define a mod class a name and the version of the mod![mod not loaded]'
  end
end

module RubyCore
  # Used to load in all the ruby mods
  class Loader
    def initialize
      puts 'initialize ran'
    end

    def loader_init
      puts 'Loader INIT'
      @path = RubyCore::Paths.new
      @gems_folder = @path.gems_folder
      @ruby_mods_folder = @path.ruby_mods_folder
      @mods_folder = @path.forge_mods_folder
      @cache_folder = @path.cache_folder
      @mods = []

      RubyCore::Gems.process_gems([{ rubygem: 'rubyzip', as: 'zip' }])
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
      puts 'Loading internal mods'
      puts File.join(File.dirname(__FILE__), 'mod', 'mod_*.rb')
      Dir[File.join(File.dirname(__FILE__), 'mod', 'mod_*.rb')].each do |m|
        puts "Loading mod #{m}"
        load m
      end

      puts RubyCoreApi::MOD_ID
      # We only wanna load external mods if the mod ID is still rubycore. If the developer modifies the mod ID the functionality below this is disabled.
      return unless RubyCoreApi::MOD_ID == 'rubycore'

      jar_mods = []
      puts 'Loading external mods into cache'
      Dir[File.join(@mods_folder, '*.jar')].each do |m|
        puts "Loading mod #{m} into cache"
        Zip::File.open(m) do |zip_file|
          zip_file.each do |entry|
            next unless entry.to_s.include?('.rb')

            jar_mods << zip_file.to_s unless jar_mods.include? zip_file.to_s
            # Iterate on them later and load in each one.
          end
        end
      end

      jar_mods.each do |file|
        extract_zip(file, @cache_folder)
      end

      Dir[File.join(@cache_folder, '*.rb')].each do |m|
        puts "Loading mod #{m} from cache"
        load m
      end
    end

    def initialize_mods
      puts 'Initializing mods...'
      $mods.each do |mod|
        puts "Initializing mod #{mod}"
        @mods << mod.new
      end
    end

    def call_method(name, args = nil)
      @mods.each_with_index do |mod, index|
        if args
          mod.send(name.to_s, args) if $mods[index].method_defined? name
        elsif $mods[index].method_defined? name
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
  end
end

RubyCore::Loader
