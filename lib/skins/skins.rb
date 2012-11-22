module EthilVan::Skins

   DEFAULT_SCALE = 4
   DEFAULT_CACHE = 24.hour.to_i

   cache_directory = File.join EthilVan::ROOT,  'cache'
   skins_directory = File.join cache_directory, 'skins'
   PREVIEW_DIR     = File.join skins_directory, 'preview'
   HEAD_DIR        = File.join skins_directory, 'head'

   Dir.mkdir cache_directory  unless Dir.exists? cache_directory
   Dir.mkdir skins_directory  unless Dir.exists? skins_directory
   Dir.mkdir PREVIEW_DIR      unless Dir.exists? PREVIEW_DIR
   Dir.mkdir HEAD_DIR         unless Dir.exists? HEAD_DIR

   def self.preview(username, scale = nil)
      scale ||= DEFAULT_SCALE
      filename = "#{File.join(PREVIEW_DIR, username)}_x#{scale}.png"
      generate_preview(username, scale, filename) if generate? filename
      return filename
   end

   def self.head(username, scale = nil)
      scale ||= DEFAULT_SCALE
      filename = "#{File.join(HEAD_DIR, username)}_x#{scale}.png"
      generate_head(username, scale, filename) if generate? filename
      return filename
   end

private

   def self.generate?(path)
      !File.exists?(path) || (Time.now - File.mtime(path)) >= DEFAULT_CACHE
   end
end

rrequire 'lib/skins/chunky_skins'
