# frozen_string_literal: true

module RewardsSystem
  class RewardCalculator
    MINIMUM_REWARD = 1 / 32.to_f
    BASE_REWARD = 1 / 2.to_f

    def self.calculate_points(level)
      reward = BASE_REWARD**level
      reward >= MINIMUM_REWARD ? reward : 0
    end
  end
end
