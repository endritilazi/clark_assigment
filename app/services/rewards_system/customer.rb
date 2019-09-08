# frozen_string_literal: true

module RewardsSystem
  class Customer
    attr_accessor :name, :invited_by, :points, :confirmed

    def initialize(name, invited_by, confirmed = false)
      @name = name
      @invited_by = invited_by
      @confirmed = confirmed
      @points = 0
    end

    def add_points(points_to_add)
      self.points = points + points_to_add
    end

    def add_points_to_inviter(level = 0)
      return unless confirmed
      return if invited_by.nil?

      points = RewardCalculator.calculate_points(level)
      return unless points.positive?

      invited_by.add_points(points)
      invited_by.add_points_to_inviter(level + 1)
    end

    def confirm_invitation
      self.confirmed = true
    end
  end
end
