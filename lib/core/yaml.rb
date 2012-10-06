require 'yaml'

module EthilVan

   def self.load_data(*path)
      path[-1] += '.yml'
      yaml = YAML.parse_file File.join(ROOT, 'assets', 'data', *path)
      yaml.to_ruby
   end
end
