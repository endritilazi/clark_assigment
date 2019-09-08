# frozen_string_literal: true

module RewardsSystem
  module DataParser
    module_function

    def parse_date_time(date, time)
      DateTime.parse("#{date} #{time}").utc
    end
  end
end
