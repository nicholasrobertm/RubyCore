# frozen_string_literal: true

class Example

  def initialize
      puts "LOADING EXAMPLE MOD"

      @BLOCKS = DeferredRegister.create(ForgeRegistries::BLOCKS, RubyCoreApi::MOD_ID);
      @ITEMS = DeferredRegister.create(ForgeRegistries::ITEMS, RubyCoreApi::MOD_ID);

      @ruby_block = Block.new(AbstractBlock::Properties.create(Material::ROCK).hardness_and_resistance(3, 10).harvest_level(2))
      @ruby_block_item = BlockItem.new(@ruby_block, Item::Properties.new().group(ItemGroup::BUILDING_BLOCKS))

      @ruby_ore = Block.new(AbstractBlock::Properties.create(Material::ROCK).hardness_and_resistance(3, 10).harvest_level(2))
      @ruby_ore_item = BlockItem.new(@ruby_ore, Item::Properties.new().group(ItemGroup::BUILDING_BLOCKS))

      @ruby_item = Item.new(Item::Properties.new().group(ItemGroup::MATERIALS))

      @BLOCKS.register("ruby_block") { @ruby_block }
      @ITEMS.register("ruby_block"){ @ruby_block_item }

      @BLOCKS.register("ruby_ore") { @ruby_ore }
      @ITEMS.register("ruby_ore"){ @ruby_ore_item }

      @ITEMS.register("ruby_item") { @ruby_item }

      puts "REGISTERING BLOCKS / ITEMS COMPLETE"


      @BLOCKS.register(FMLJavaModLoadingContext.get().get_mod_event_bus());
      @ITEMS.register(FMLJavaModLoadingContext.get().get_mod_event_bus());

      # Register ourselves for server and other game events we are interested in
      MinecraftForge::EVENT_BUS.register(self);
  end

end

add_mod(Example, 'Example', '0.1')
