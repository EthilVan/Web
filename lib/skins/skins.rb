module EthilVan::Skins

   DEFAULT_SCALE = 4

   cache_directory = File.join EthilVan::ROOT, 'cache'
   skins_directory = File.join cache_directory, 'skins'
   PREVIEW_DIR     = File.join skins_directory, "preview"
   HEAD_DIR        = File.join skins_directory, "head"

   Dir.mkdir cache_directory  unless Dir.exists? cache_directory
   Dir.mkdir skins_directory  unless Dir.exists? skins_directory
   Dir.mkdir PREVIEW_DIR      unless Dir.exists? PREVIEW_DIR
   Dir.mkdir HEAD_DIR         unless Dir.exists? HEAD_DIR

   def self.preview(username, scale = DEFAULT_SCALE)
      filename = File.join(PREVIEW_DIR, username) + '.png'
      unless File.exists? filename
         generate_preview(username, scale, filename)
      end
      return filename
   end

   def self.head(username, scale = DEFAULT_SCALE)
      filename = File.join(HEAD_DIR, username) + '.png'
      unless File.exists? filename
         generate_head(username, scale, filename)
      end
      return filename
   end

   if RUBY_PLATFORM == 'java'
      rrequire 'lib/skins/java_skins'
   else
      rrequire 'lib/skins/chunky_skins'
   end
end
