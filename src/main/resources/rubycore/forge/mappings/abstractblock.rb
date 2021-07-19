class AbstractBlock::Properties
      def self.create(arg0, arg1 ='')
        return func_200945_a(arg0) if arg1.empty?
        case arg1.class
        when MaterialColor
          return func_200949_a(arg0,arg1)
        when DyeColor
          return func_200952_a(arg0,arg1)
        when Function
          return func_235836_a_(arg0,arg1)
        end
      end

      def copy(arg0)
        func_200950_a(arg0)
      end

      def friction(arg0)
        func_200941_a(arg0)
      end

      def no_collission
        func_200942_a
      end

      def jump_factor(arg0)
        func_226898_c_(arg0)
      end

      def drops_like(arg0)
        func_222379_b(arg0)
      end

      def has_post_process(arg0)
        func_235852_d_(arg0)
      end

      def strength(arg0, arg1 ='')
        return func_200943_b(arg0) if arg1.is_a? String
        return func_200948_a(arg0,arg1) unless arg1.is_a? String
      end

      def hardness_and_resistance(arg0, arg1='')
        strength(arg0, arg1)
      end

      def random_ticks
        func_200944_c
      end

      def sound(arg0)
        func_200947_a(arg0)
      end

      def instabreak
        func_200946_b
      end

      def is_view_blocking(arg0)
        func_235847_c_(arg0)
      end

      def is_redstone_conductor(arg0)
        func_235828_a_(arg0)
      end

      def is_suffocating(arg0)
        func_235842_b_(arg0)
      end

      def requires_correct_tool_for_drops
        func_235861_h_
      end

      def no_drops
        func_222380_e
      end

      def dynamic_shape
        func_208770_d
      end

      def no_occlusion
        func_226896_b_
      end

      def emissive_rendering(arg0)
        func_235856_e_(arg0)
      end

      def is_valid_spawn(arg0)
        func_235827_a_(arg0)
      end

      def air
        func_235859_g_
      end

      def speed_factor(arg0)
        func_226897_b_(arg0)
      end

      def light_level(arg0)
        func_235838_a_(arg0)
      end

end