class Time

   def interval
      Interval.new(self)
   end

   class Interval

      Messages = EthilVan.load_data "time_interval"

      T0 = Time.at 0

      def initialize(from, to = Time.now)
         @diff = Time.at(to - from)
      end

      def year
         @year ||= @diff.year - T0.year
      end

      def month
         @month ||= @diff.month - T0.month
      end

      def week
         day / 7
      end

      def day
         @day ||= @diff.day - T0.day
      end

      def hour
         @hour ||= @diff.hour - T0.hour
      end

      def minutes
         @minutes ||= @diff.minutes - T0.minutes
      end

      def seconds
         @seconds ||= @diff.seconds - T0.seconds
      end

      def format(context)
         if year > 0
            return Messages["yearplus"][context]
         end
         if month > 2
            return Messages["month2plus"][context]
         end
         if month == 2
            return Messages["month2"][context]
         end
         if month == 1
            return Messages["month1"][context]
         end
         if week > 2
            return Messages["week3plus"][context]
         end
         if week == 2
            return Messages["week2"][context]
         end
         if week == 1
            return Messages["week1"][context]
         end
         if day > 2
            return Messages["day2plus"][context]
         end
         if day == 2
            return Messages["day2"][context]
         end
         if day == 1
            return Messages["day1"][context]
         end
         if hour > 2
            return Messages["hour2plus"][context]
         end
         if hour == 2
            return Messages["hour2"][context]
         end
         if hour > 1
            return Messages["hour1"][context]
         end
         return Messages["hour0"][context]
      end

      def format_since
         format('depuis')
      end

      def format_ago
         format('ilya')
      end
   end
end
