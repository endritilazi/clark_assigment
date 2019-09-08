# frozen_string_literal: true

module RewardsSystem
  class ApiFormatter
    def self.parse_rewards_points(customers_collections)
      formatted = {}
      customers_collections.each { |c| formatted[c.name] = c.points if c.points.positive? }
      formatted
    end
  end
end
