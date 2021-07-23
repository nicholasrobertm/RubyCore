
module RubyCore
  module API
   def API::is_client?
     return FMLEnvironment.dist == Dist::CLIENT
   end

  end
end