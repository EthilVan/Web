require 'net/http'

module EthilVan::Skins

   class Updater

      MINECRAFT_BASE_URL = 'http://s3.amazonaws.com/MinecraftSkins/'

      def self.update_all
         puts 'Updating all skins ...'
         thread = [new('char').update]
         thread += accounts_from_db.map { |account| new(account).update }
         sleep(10) while thread.any?(&:alive?)
      end

      def self.accounts_from_db
         db = EthilVan::Config.database
         command =  'mysql'
         command << " -h #{db['host']}"
         command << " -u #{db['username']}"
         command << " --password=#{db['password']}"
         command << " --batch"
         command << " #{db['database']}"
         command << " -e "
         command << "\"SELECT minecraft_name FROM accounts;\""

         res = `#{command}`.split("\n")
         res.shift
         res
      end

      def initialize(name)
         @name = name
         @raw = Skin.new(@name)
      end

      def update
         Thread.new do
            status = do_update
            puts "#@name ... #{status} !"
         end
      end

   private

      def do_update
         response = Net::HTTP.get_response skin_uri_for @name
         return 'Not Found' if response.code != '200'

         last_modified = response['Last-Modified']
         last_modified = Time.parse last_modified
         return 'Up-to-date' unless @raw.need_update? last_modified

         @raw.replace(response.body)

         PREGENERATED.each do |klass, scales|
            scales.each { |scale| update_generated(klass, scale) }
         end
         return 'Updated'
      end

      def update_generated(klass, scale)
         generated = klass.new(@name, scale, @raw)
         if generated.need_update? @raw.mtime
            generated.generate
         end
      end

      def skin_uri_for(username)
         URI("#{MINECRAFT_BASE_URL}#{username}.png")
      end
   end
end
