class ActivityStat < ActiveRecord::Base

   belongs_to :account, inverse_of: :activity_stat

   def value
      sql = sql_value
      return sql.nil? ? 0 : sql_value
   end
end
