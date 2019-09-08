# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsSystem::ApiFormatter do
  describe 'Should get correct format for api' do
    let(:file_data) do
      <<-INPUT_DATA
          2018-06-12 09:41 A recommends B
          2018-06-14 09:41 B accepts
          2018-06-16 09:41 B recommends C
          2018-06-17 09:41 C accepts
          2018-06-19 09:41 C recommends D
          2018-06-23 09:41 B recommends D
          2018-06-25 09:41 D accepts
      INPUT_DATA
    end

    it do
      expected_result = { A: 1.75, B: 1.5, C: 1 }
      costumers_collection = RewardsSystem::FileInputParser.new(file_data).populate_customers_collection
      costumers_collection.calculate_rewards

      expect(RewardsSystem::ApiFormatter.parse_rewards_points(costumers_collection).symbolize_keys).to eq expected_result
    end
  end
end
