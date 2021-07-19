# frozen_string_literal: true

# Class used to hold all the minecraft registries
class Registry
  def initialize(mod_id = RubyCoreApi::MOD_ID)
    @BIOMES = DeferredRegister.create(ForgeRegistries::BIOMES, mod_id)
    @BLOCKS = DeferredRegister.create(ForgeRegistries::BLOCKS, mod_id)
    @ENCHANTMENTS = DeferredRegister.create(ForgeRegistries::ENCHANTMENTS, mod_id)
    @ITEMS = DeferredRegister.create(ForgeRegistries::ITEMS, mod_id)
    @POTION_TYPES = DeferredRegister.create(ForgeRegistries::POTION_TYPES, mod_id)
    @POTIONS = DeferredRegister.create(ForgeRegistries::POTIONS, mod_id)
    @SOUND_EVENTS = DeferredRegister.create(ForgeRegistries::SOUND_EVENTS, mod_id)
    # VILLAGER_PROFESSIONS = DeferredRegister.create(ForgeRegistries::VILLAGER_PROFESSIONS, mod_id)
  end

  def post_initialize
    @BIOMES.register(FMLJavaModLoadingContext.get.get_mod_event_bus)
    @BLOCKS.register(FMLJavaModLoadingContext.get.get_mod_event_bus)
    @ENCHANTMENTS.register(FMLJavaModLoadingContext.get.get_mod_event_bus)
    @ITEMS.register(FMLJavaModLoadingContext.get.get_mod_event_bus)
    @POTION_TYPES.register(FMLJavaModLoadingContext.get.get_mod_event_bus)
    @POTIONS.register(FMLJavaModLoadingContext.get.get_mod_event_bus)
    @SOUND_EVENTS.register(FMLJavaModLoadingContext.get.get_mod_event_bus)
    # VILLAGER_PROFESSIONS.register(FMLJavaModLoadingContext.get().get_mod_event_bus())
  end

  def register_biome(name, biome)
    @BIOMES.register(name) { biome }
  end

  def register_block(name, block)
    @BLOCKS.register(name) { block }
  end

  def register_enchantment(name, enchantment)
    @ENCHANTMENTS.register(name) { enchantment }
  end

  def register_item(name, item)
    @ITEMS.register(name) { item }
  end

  def register_potion_type(name, potion_type)
    @POTION_TYPES.register(name) { potion_type }
  end

  def register_potion(name, potion)
    @POTIONS.register(name) { potion }
  end
end
