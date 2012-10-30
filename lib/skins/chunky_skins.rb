require 'net/http'

module EthilVan::Skins

   def self.generate_preview(username, scale, filename)
      skin = Skin.new username
      skin.preview(scale).save filename
   end

   def self.generate_head(username, scale, filename)
      skin = Skin.new username
      skin.head_with_helmet(scale).save filename
   end

   class SkinImage < ::ChunkyPNG::Image

      include ChunkyPNG::Color

      def initialize(*args)
         super(*args)
         set_opaque(        0...32,  0...16)
         set_opaque(        0...64, 16...32)
         set_transparent(  32...64,  0...16)
      end

      def has_transparency?(x_range, y_range)
         for i in x_range
            for j in y_range
               return true if a(self[i, j]) < 0xff
            end
         end

         return false
      end

      def set_opaque(x_range, y_range)
         for i in x_range
            for j in y_range
               color = self[i, j]
               self[i, j] = rgba(r(color), g(color), b(color), 0xff)
            end
         end
      end

      def set_transparent(x_range, y_range)
         return if has_transparency? x_range, y_range
         workaround_alpha = self[x_range.begin, y_range.begin]
         for i in x_range
            for j in y_range
               if self[i, j] == workaround_alpha
                  self[i, j] = TRANSPARENT
               end
            end
         end
      end

      def crop_rescale(x, y, w, h, scale)
         cropped = crop(x, y, w, h)
         return cropped if scale == 1
         return cropped.resample_nearest_neighbor(w * scale, h * scale)
      end
   end

   class Skin

      def initialize(username)
         uri = URI("http://s3.amazonaws.com/MinecraftSkins/#{username}.png")
         begin
            @image = SkinImage.from_blob Net::HTTP.get uri
         rescue Exception => e
            char = File.read("./public/images/member/profil/char.png")
            @image = SkinImage.from_blob char
         end
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
         right_arm(scale).flip_vertically
      end

      def right_arm(scale)
         @image.crop_rescale(44, 20, 4, 12, scale)
      end

      def left_leg(scale)
         right_leg(scale).flip_vertically
      end

      def right_leg(scale)
         @image.crop_rescale(4, 20, 4, 12, scale)
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
