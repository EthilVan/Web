class ActiveRecord::Migration

   def self.raw_sql(migration_file)
      dir = File.dirname migration_file
      base = File.basename migration_file, ".rb"

      upfile = File.join(dir, "sql", base + "_up.sql")
      downfile = File.join(dir, "sql", base + "_down.sql")

      define_method("up") do
         execute_raw_sql_file upfile
      end

      define_method("down") do
         execute_raw_sql_file downfile
      end
   end

   def execute_raw_sql_file(file)
      return unless File.exists? file
      statements = File.read file
      statements.split(";").map(&:strip).reject(&:empty?)
            .each do |statement|
         execute statement
      end
   end
end
