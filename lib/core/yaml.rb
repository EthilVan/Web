require 'yaml'

module EthilVan

   def self.load_data(*path)
      path[-1] += '.yml'
      yaml = YAML.parse_file File.join(ROOT, 'assets', 'data', *path)
      yaml.to_ruby
   end

   def self.load_datas(*path_args)
      path = File.join(ROOT, 'assets', 'data', *path_args, '**/*.yml')
      Dir[path].map { |file| YAML.parse_file(file).to_ruby }
   end
end
