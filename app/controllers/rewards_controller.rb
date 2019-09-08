# frozen_string_literal: true

class RewardsController < ApplicationController
  def calculate
    validator = RewardsSystem::Validators::InputValidator.new(request.raw_post)
    return render json: validator.errors, status: :unprocessable_entity unless validator.valid?

    costumers_collection = RewardsSystem::FileInputParser.new(request.raw_post).populate_customers_collection
    costumers_collection.calculate_rewards

    render json: RewardsSystem::ApiFormatter.parse_rewards_points(costumers_collection)
  end
end
