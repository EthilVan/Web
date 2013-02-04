require 'net/http'

module EthilVan::Skins

   class Updater

      MINECRAFT_BASE_URL = 'http://s3.amazonaws.com/MinecraftSkins/'

      def self.update_all
         new('char').update
         accounts_from_db.each { |account| new(account).update }
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
         puts_line
         puts "Updating '#{@name}' skin"
         do_update
         puts_line
      end

   private

      def do_update
         puts 'Downloading ...'
         response = Net::HTTP.get_response skin_uri_for @name
         if response.code != '200'
            puts 'Raw skin not found'
            return
         end

         last_modified = response['Last-Modified']
         last_modified = Time.parse last_modified
         unless @raw.need_update? last_modified
            puts 'Skin up-to-date'
            return
         end

         puts 'Replacing raw skin'
         @raw.replace(response.body)

         PREGENERATED.each do |klass, scales|
            scales.each { |scale| update_generated(klass, scale) }
         end
      end

      def update_generated(klass, scale)
         puts "Generating #{klass.name.downcase} at scale #{scale}"
         generated = klass.new(@name, scale, @raw)
         if generated.need_update? @raw.mtime
            generated.generate
         end
      end

      def puts(*args)
         first = args.shift
         super('#  ' + first, *args)
      end

      def puts_line
         Kernel.puts('# ' + '=' * 60)
      end

      def skin_uri_for(username)
         URI("#{MINECRAFT_BASE_URL}#{username}.png")
      end
   end
end
