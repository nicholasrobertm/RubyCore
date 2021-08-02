# A quick example of how you can write a server-side only script to process events / doing things on the server.
# @events below contains one copy of each event that gets triggered when the script is running, it's useful for grabbing the converted names of events you
# might want to use.
# Events are passed in from the EventBus in RubyCore to the process_event method which then can be consumed.
class MyServerScript
    def initialize
        puts "Test Initialize called"
		puts FMLPaths::GAMEDIR.get().to_file()

		@events = []
	end

	def process_event(event)
		puts event.class.to_s unless @events.include? event.class.to_s
		@events << event.class.to_s unless @events.include? event.class.to_s
		case event.class.to_s
		when "Java::NetMinecraftforgeFmlEventServer::FMLServerStartedEvent"
		  @server = event.server
		  puts "server started yay!"
		when "Java::NetMinecraftforgeFmlEventServer::FMLServerStoppedEvent"
		  puts "Server stopping yay!"
		when "Java::NetMinecraftforgeEventEntityPlayer::PlayerEvent::PlayerLoggedInEvent"
		  puts event.get_player.get_ip_address
		  @server.get_commands.perform_command(@server.create_command_source_stack, 'say testing test test test')
		else

		end
	end
end
RubyCore::Loader.add_mod(MyServerScript, 'MyServerScript', '0.1')