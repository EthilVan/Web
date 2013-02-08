module EthilVan

   def load_data(*path)
      path[-1] += '.yml'
      yaml = YAML.parse_file path('content', 'data', *path)
      yaml.to_ruby
   end

   def load_datas(*path_args)
      path = path('content', 'data', *path_args, '**/*.yml')
      Dir[path].map { |file| YAML.parse_file(file).to_ruby }
   end

   # Ensure this is loaded now
   require 'active_support/time'

   # Libs
   require 'ethilvan'
   require 'ethilvan/require'
   require 'ethilvan/logger'
   require 'ethilvan/cron'
   require 'ethilvan/static'
   require 'ethilvan/mustache'
   require 'ethilvan/auth'
   require 'ethilvan/misc'
   require 'ethilvan/markdown'
   require 'ethilvan/skins'
end
