
# Class to create an ore
class OreBlock < Block

  def initialize(options)
    # Assign all the default values, then pass the basics to the Block Class
    raise 'You must specify a name for the ore in options[:name]' unless options[:name]
    @options = {}
    @options[:material] = options[:material] || Material::ROCK
    @options[:hardness] = options[:hardness] || 3
    @options[:resistance] = options[:resistance] || 10
    @options[:harvest_level] = options[:harvest_level] || 3
    @options[:group] = options[:group] || ItemGroup::BUILDING_BLOCKS
    @options[:name] = options[:name]
    @options[:drop_self] = options[:drop_self] || false
    @options[:block_form] = options[:block_form] || true
    @options[:item_drop_group] = options[:item_drop_group] || ItemGroup::MATERIALS

    super(AbstractBlock::Properties.create(@options[:material]).hardness_and_resistance(@options[:hardness], @options[:resistance]).harvest_level(@options[:harvest_level]))

    # Create an item for the ore
    @block_item = BlockItem.new(self, Item::Properties.new().group(@options[:group]))

    @drop_item = Item.new(Item::Properties.new().group(ItemGroup::MATERIALS)) unless @options[:drop_self]

    @block_form_block = Block.new(AbstractBlock::Properties.create(@options[:material]).hardness_and_resistance(@options[:hardness], @options[:resistance]).harvest_level(@options[:harvest_level]))
    @block_form_block_item = BlockItem.new(@block_form_block, Item::Properties.new().group(@options[:group]))
  end

  def register_all(registry)
    registry.register_block(@options[:name] + '_ore', self)
    registry.register_item(@options[:name] + '_ore', @block_item)
    registry.register_item(@options[:name], @drop_item)
    registry.register_block(@options[:name] + '_block', @block_form_block)
    registry.register_item(@options[:name] + '_block', @block_form_block_item)
  end

  def get_experience_when_mined(random)
    1
  end

end



