require_relative "paths"

module RubyCore
	module Gems
		@path = RubyCore::Paths.new
		def self.process_gems(gems)
			unless gems.empty?
				Gem.paths = {'GEM_HOME' => @path.gems_folder}
			end
			gems.each {|g| load_gem(g) }
		end


		def self.require_gem(g)
			if g.is_a?(Hash)
				if g[:as]
					require g[:as]
				else
					require g[:rubygem]
				end
			else
				require g
			end
		end

		def self.load_gem(g)
			begin
				require_gem(g)
			rescue LoadError
					download_gems(g)
				begin
					require_gem(g)
				rescue LoadError => error
					puts "Sorry but i can't install the #{g[:rubygem]}, sorry :("
					puts error
					puts error.inspect
				end
			end
		end

		def self.download_gems(g)
		    begin
    			system("java -classpath '#{@path.rubycore_location}' org.jruby.Main -S gem install --install-dir #{@path.gems_folder} #{g[:rubygem]} --no-document --verbose")
		    rescue StandardError => error
		    	puts "Path: #{@path.rubycore_location}"
                puts error
                puts error.inspect
		    end

		end
	end
end
