# frozen_string_literal: true

require_relative 'paths'

module RubyCore
  # Used for downloading gems where jruby can access
  module Gems
    @path = RubyCore::Paths.new
    def self.process_gems(gems)
      Gem.paths = { 'GEM_HOME' => @path.gems_folder } unless gems.empty?
      gems.each { |gem_to_download| load_gem(gem_to_download) }
    end

    def self.require_gem(gem_to_download)
      if gem_to_download.is_a?(Hash)
        if gem_to_download[:as]
          require gem_to_download[:as]
        else
          require gem_to_download[:rubygem]
        end
      else
        require gem_to_download
      end
    end

    def self.load_gem(gem_to_download)
      require_gem(gem_to_download)
    rescue LoadError
      download_gems(gem_to_download)
      begin
        require_gem(gem_to_download)
      rescue LoadError => error
        puts "Sorry but i can't install the #{gem_to_download[:rubygem]}, sorry :("
        puts error
        puts error.inspect
      end
    end

    def self.download_gems(gem_to_download)
      system("java -classpath '#{@path.rubycore_location}' org.jruby.Main -S gem install --install-dir #{@path.gems_folder} #{gem_to_download[:rubygem]} --no-document --verbose")
    rescue StandardError => e
      puts "Path: #{@path.rubycore_location}"
      puts e
      puts e.inspect
    end
  end
end
