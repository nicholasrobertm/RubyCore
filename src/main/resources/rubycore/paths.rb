# frozen_string_literal: true

java_import 'net.minecraftforge.fml.loading.FMLPaths'
require 'fileutils'
require 'shellwords'

module RubyCore
  # Gets various paths common to mod installs
  class Paths
    def minecraft_folder
      FMLPaths::GAMEDIR.get().to_file().to_s
    end

    def rubycore_folder
      FMLPaths::GAMEDIR.get().resolve(RubyCoreApi::MOD_ID).to_file().to_s
    end

    def forge_mods_folder
      join_path(File.join(minecraft_folder, 'mods'))
    end

    def rubycore_location
      join_path(File.join(minecraft_folder, 'mods', "#{RubyCoreApi::MOD_ID}-#{RubyCoreApi::MOD_VERSION}"))
    end

    def ruby_mods_folder
      join_path(File.join(rubycore_folder, 'scripts'))
    end

    def gems_folder
      join_path(File.join(rubycore_folder, 'gems'))
    end

    def assets_folder
      join_path(File.join(rubycore_folder, 'assets'))
    end

    def cache_folder
      join_path(File.join(rubycore_folder, 'cache'))
    end

    def exist?(path)
      Dir.exist?(path)
    end

    # Note - This is to get around windows path formatting which JRuby / ruby does NOT like combined with the wrong slash format
    def join_path(path)
      if path.include?('\\') && path.include?('/')
        path.gsub('\\', '/')
      else
        path
      end
    end

    def create(path)
      FileUtils.mkdir_p(path) unless exist?(path) || path.nil?
    end
  end
end
