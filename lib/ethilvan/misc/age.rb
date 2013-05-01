class AgeUtil

   def self.from_dob(dob, date = Date.today)
      day_diff = date.day - dob.day
      month_diff = date.month - dob.month - (day_diff < 0 ? 1 : 0)
      date.year - dob.year - (month_diff < 0 ? 1 : 0)
   end
end
