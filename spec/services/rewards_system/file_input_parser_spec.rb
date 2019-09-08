# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsSystem::FileInputParser do
  let(:file_input_parser) { described_class.new(file_data) }

  describe 'Should parse lines to collection ' do
    before(:each) do
      @customer_collection = file_input_parser.populate_customers_collection
    end

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

    it 'Should be customers collections' do
      expect(@customer_collection).to be_kind_of(RewardsSystem::CustomersCollection)
    end

    it 'Should have 4 customers' do
      expect(@customer_collection.size).to eq 4
    end
  end
end
