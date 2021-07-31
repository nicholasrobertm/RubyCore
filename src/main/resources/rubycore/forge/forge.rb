# frozen_string_literal: true


java_import 'net.minecraftforge.common.MinecraftForge'
java_import 'net.minecraftforge.eventbus.api.IEventBus'
java_import 'net.minecraftforge.registries.DeferredRegister'
java_import 'net.minecraftforge.registries.ForgeRegistries'
java_import 'net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext'
java_import 'net.minecraftforge.fml.loading.FMLEnvironment'

require 'rubycore/forge/client' if RubyCore::API.is_client?
require 'rubycore/forge/registry'
require 'rubycore/forge/ore_block'
# require 'rubycore/scripts/forge_mappings_generator'
if defined?(Material::field_151576_e)
  require 'rubycore/forge/mappings/abstractblock'
  require 'rubycore/forge/mappings/material'
  require 'rubycore/forge/mappings/itemgroup'
  require 'rubycore/forge/mappings/item' if RubyCore::API.is_client?
end
