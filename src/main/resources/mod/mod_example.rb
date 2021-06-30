# frozen_string_literal: true

# This is an example of what a mod can look like
class Example
  def initialize
    puts 'LOADING EXAMPLE MOD'

    @registry = Registry.new

    @ruby_block = Block.new(AbstractBlock::Properties.create(Material::ROCK).hardness_and_resistance(3,
                                                                                                     10).harvest_level(2))
    @ruby_block_item = BlockItem.new(@ruby_block, Item::Properties.new.group(ItemGroup::BUILDING_BLOCKS))

    @ruby_ore = OreBlock.new({ name: 'ruby' })
    @ruby_ore.register_all(@registry)

    # Registers all the registries at once with the mod event bus
    @registry.post_initialize

    # Register ourselves for server and other game events we are interested in
    MinecraftForge::EVENT_BUS.register(self)
  end
end

add_mod(Example, 'Example', '0.1')
