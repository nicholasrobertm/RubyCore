# frozen_string_literal: true

require 'json'
require 'fileutils'

# Used to manage and generate assets for blocks, items, etc. Also includes recipes and loot tables
class AssetManager
  attr_accessor :resource_path, :blockstates_path, :models_block_path, :models_item_path, :recipes_path, :loot_tables_block_path, :loot_tables_chests_path, :loot_tables_entities_path,
                :loot_tables_gameplay_path

  def initialize(resource_path, mod_id = 'rubycore')
    @resource_path = resource_path
    @mod_id = mod_id
    @blockstates_path = "#{@resource_path}/assets/#{@mod_id}/blockstates/"
    @models_block_path = "#{@resource_path}/assets/#{@mod_id}/models/block/"
    @models_item_path = "#{@resource_path}/assets/#{@mod_id}/models/item/"
    @loot_tables_block_path = "#{@resource_path}/data/#{@mod_id}/loot_tables/blocks/"
    @loot_tables_chests_path = "#{@resource_path}/data/#{@mod_id}/loot_tables/chests/"
    @loot_tables_entities_path = "#{@resource_path}/data/#{@mod_id}/loot_tables/entities/"
    @loot_tables_gameplay_path = "#{@resource_path}/data/#{@mod_id}/loot_tables/gameplay/"
    @recipes_path = "#{@resource_path}/data/#{@mod_id}/recipes/"
  end

  def create_block_model(name, type = 'simple')
    create_registry_entry(@models_block_path, name, generate_model(name, 'block', type))
  end

  def create_item_model(name, type = 'simple')
    create_registry_entry(@models_item_path, name, generate_model(name, 'item', type))
  end

  def create_blockstate(name, type = 'simple')
    create_registry_entry(@blockstates_path, name, generate_blockstate(name, type))
  end

  def create_block_loot_table(name, type = 'simple')
    create_registry_entry(@loot_tables_block_path, name, generate_loot_table(name, 'blocks', type))
  end

  def create_chest_loot_table(name, type = 'simple')
    create_registry_entry(@loot_tables_chests_path, name, generate_loot_table(name, 'chests', type))
  end

  def create_entity_loot_table(name, type = 'simple')
    create_registry_entry(@loot_tables_chests_path, name, generate_loot_table(name, 'entities', type))
  end

  def create_gameplay_loot_table(name, type = 'simple')
    create_registry_entry(@loot_tables_gameplay_path, name, generate_loot_table(name, 'gameplay', type))
  end

  def create_crafting_shaped_recipe(name, recipe_data)
    create_registry_entry(@recipes_path, name, generate_recipe(name, 'crafting_shaped', recipe_data))
  end

  def create_crafting_shapeless_recipe(name, recipe_data)
    create_registry_entry(@recipes_path, name, generate_recipe(name, 'crafting_shapeless', recipe_data))
  end

  def create_smelting_recipe(name, recipe_data)
    create_registry_entry(@recipes_path, name, generate_recipe(name, 'smelting', recipe_data))
  end

  def create_block_model_json(name, content)
    create_registry_entry(@models_block_path, name, content)
  end

  def create_item_model_json(name, content)
    create_registry_entry(@models_item_path, name, content)
  end

  def create_blockstate_json(name, content)
    create_registry_entry(@blockstates_path, name, content)
  end

  def create_block_loot_table_json(name, content)
    create_registry_entry(@loot_tables_block_path, name, content)
  end

  def create_chest_loot_table_json(name, content)
    create_registry_entry(@loot_tables_chests_path, name, content)
  end

  def create_entity_loot_table_json(name, content)
    create_registry_entry(@loot_tables_chests_path, name, content)
  end

  def create_gameplay_loot_table_json(name, content)
    create_registry_entry(@loot_tables_gameplay_path, name, content)
  end

  def create_crafting_shaped_recipe_json(name, content)
    create_registry_entry(@recipes_path, name, content)
  end

  def create_crafting_shapeless_recipe_json(name, content)
    create_registry_entry(@recipes_path, name, content)
  end

  def create_smelting_recipe_json(name, content)
    create_registry_entry(@recipes_path, name, content)
  end

  def load_registry_template(registry_type, type)
    types = Dir.children("registry_templates/#{registry_type}/")
    raise "#{registry_type} type #{type} does not exist" unless types.include?("#{type}.json")

    JSON.parse(File.read("registry_templates/#{registry_type}/#{type}.json"))
  end

  def create_registry_entry(path, name, content)
    FileUtils.mkdir_p(path)
    File.open("#{path}#{name}.json", 'w') do |file|
      file.write(content)
    end
  end

  def generate_blockstate(name, type = 'simple')
    blockstate = load_registry_template('blockstates', type)
    blockstate['variants']['']['model'] = case type
                                          when 'simple'
                                            "#{@mod_id}:block/#{name}"
                                          end

    JSON.pretty_generate blockstate
  end

  def generate_model(name, model_type, type = 'simple')
    model = load_registry_template('models', type)
    case type
    when 'simple'
      model['textures']['all'] = "#{@mod_id}:#{model_type}/#{name}"
    when 'orientable'
      model['textures']['top'] = "#{@mod_id}:#{model_type}/#{name}_top"
      model['textures']['front'] = "#{@mod_id}:#{model_type}/#{name}_front"
      model['textures']['side'] = "#{@mod_id}:#{model_type}/#{name}_side"
    else
      model['textures']['all'] = "#{@mod_id}:#{model_type}/#{name}"
    end
    JSON.pretty_generate model
  end

  def generate_loot_table(name, loot_table_type, type = 'simple')
    loot_table = load_registry_template('loot_tables', "#{type}_#{loot_table_type}")
    loot_table['pools']['entries'][0]['name'] = case "#{type}_# {loot_table_type}"
                                                when 'simple_block'
                                                  "#{@mod_id}:#{name}"
                                                when 'simple_block_explodable'
                                                  "#{@mod_id}:#{name}"
                                                else
                                                  puts 'loot table incorrect'
                                                end

    JSON.pretty_generate loot_table
  end

  def generate_recipe(name, type, recipe_data)
    recipe = load_registry_template('recipes', type)

    case recipe
    when 'crafting_shaped'
      recipe['pattern'] = recipe_data[:pattern]
      recipe['result']['item'] = recipe_data[:result] || "#{@mod_id}:#{name}"
      recipe['result']['count'] = recipe_data[:count] || 1
      recipe_data[:item_keys].each do |item_key|
        recipe['key'][item_key[:key]]['item'] = item_key[:ingredient]
      end
    when 'crafting_shapeless'
      recipe['result']['item'] = recipe_data[:result]
      recipe['result']['count'] = recipe_data[:count] || 1
      recipe['ingredients'] = recipe_data[:ingredients]
    when 'smelting'
      recipe['ingredient']['item'] = recipe_data[:ingredient]
      recipe['result']['item'] = recipe_data[:result] || "#{@mod_id}:#{name}"
      recipe['experience'] = recipe_data[:experience] || 0.7
      recipe['cookingtime'] = recipe_data[:cookingtime] || 200
    else
      puts 'recipe type doesnt exist'
    end
  end
end
