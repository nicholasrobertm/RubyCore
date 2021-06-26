require 'fileutils'

module RubyCore
	class Paths
		def minecraft_folder
			RubyCoreApi.minecraft_home.to_s
		end

		def rubycore_folder
        	RubyCoreApi.rubycore_home.to_s
        end

		def forge_mods_folder
			join_path(File.join(minecraft_folder, 'mods'))
		end

		def ruby_mods_folder
        	join_path(File.join(rubycore_folder, 'mods'))
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
                return path.gsub('\\', '/')
            else
                return path
            end
        end

		def create(path)
			FileUtils.mkdir_p(path) unless exist?(path) || path.nil?
		end
	end
end
