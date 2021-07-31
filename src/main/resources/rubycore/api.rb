java_import 'net.minecraftforge.fml.loading.FMLEnvironment'
java_import 'net.minecraftforge.api.distmarker.Dist'

module RubyCore
  module API

   def API::is_client?
     return FMLEnvironment.dist == Dist::CLIENT
   end

   def API::is_server?
     return !API::is_client?
   end

  end
end
