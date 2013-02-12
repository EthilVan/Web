require 'net/http'
require 'chunky_png'

module EthilVan::Skins

   class Preview

      def generate
         skin = Chunky::Skin.new @raw
         skin.preview(@scale).save @file.to_s
      end
   end

   class Head

      def generate
         skin = Chunky::Skin.new @raw
         skin.head_with_helmet(@scale).save @file.to_s
      end
   end

   module Chunky

      class SkinImage < ::ChunkyPNG::Image

         include ChunkyPNG::Color

         def initialize(*args)
            super(*args)
            set_opaque(        0...32,  0...16)
            set_opaque(        0...64, 16...32)
            set_transparent(  32...64,  0...16)
         end

         def has_transparency?(x_range, y_range)
            x_range.each { |i| y_range.each { |j|
               return true if a(self[i, j]) < 0xff
            } }

            return false
         end

         def set_opaque(x_range, y_range)
            x_range.each { |i| y_range.each { |j|
               color = self[i, j]
               self[i, j] = rgba(r(color), g(color), b(color), 0xff)
            } }
         end

         def set_transparent(x_range, y_range)
            return if has_transparency? x_range, y_range
            workaround_alpha = self[x_range.begin, y_range.begin]
            x_range.each { |i| y_range.each { |j|
               if self[i, j] == workaround_alpha
                  self[i, j] = TRANSPARENT
               end
            } }
         end

         def crop_rescale(x, y, w, h, scale)
            cropped = crop(x, y, w, h)
            return cropped if scale == 1
            return cropped.resample_nearest_neighbor(w * scale, h * scale)
         end
      end

      class Skin

         def initialize(raw)
            @image = SkinImage.from_file raw.get
         end

         def head(scale)
            @image.crop_rescale(8, 8, 8, 8, scale)
         end

         def helmet(scale)
            @image.crop_rescale(40, 8, 8, 8, scale)
         end

         def body(scale)
            @image.crop_rescale(20, 20, 8, 12, scale)
         end

         def left_arm(scale)
            @left_arm ||= {}
            @left_arm[scale] ||= @image.crop_rescale(44, 20, 4, 12, scale)
         end

         def right_arm(scale)
            left_arm(scale).flip_vertically
         end

         def left_leg(scale)
            @left_leg ||= {}
            @left_leg[scale] ||= @image.crop_rescale(4, 20, 4, 12, scale)
         end

         def right_leg(scale)
            left_leg(scale).flip_vertically
         end

         def preview(scale)
            img = ::ChunkyPNG::Image.new(16 * scale, 32 * scale,
                  ::ChunkyPNG::Color::TRANSPARENT)

            img.replace!(head(scale),          4 * scale,  0 * scale)
            img.compose!(helmet(scale),        4 * scale,  0 * scale)
            img.replace!(body(scale),          4 * scale,  8 * scale)
            img.replace!(left_arm(scale),      0 * scale,  8 * scale)
            img.replace!(right_arm(scale),    12 * scale,  8 * scale)
            img.replace!(left_leg(scale),      4 * scale, 20 * scale)
            img.replace(right_leg(scale),      8 * scale, 20 * scale)
         end

         def head_with_helmet(scale)
            img = ::ChunkyPNG::Image.new(8 * scale, 8 * scale,
                  ::ChunkyPNG::Color::TRANSPARENT)

            img.replace!(head(scale),  0, 0)
            img.compose(helmet(scale), 0, 0)
         end
      end
   end
end
