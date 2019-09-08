# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsSystem::CustomersCollection do
  let(:customer) { RewardsSystem::Customer.new('A', nil, false) }
  let(:invited_customer) { RewardsSystem::Customer.new('B', customer, false) }
  let(:customers_collection) { described_class.new }

  context 'Adding customer without inviter' do
    describe 'Adding customer' do
      before(:each) do
        @customers_collection = customers_collection
        @customers_collection.add('A', customer)
      end
      it 'should has one customer' do
        expect(@customers_collection.size).to eq 1
        expect(@customers_collection.customers.keys).to eq ['A']
      end

      it 'customer should be unconfirmed' do
        expect(@customers_collection.get('A').confirmed).to eq false
      end

      it 'customer should not has inviter' do
        expect(@customers_collection.get('A').invited_by).to be_nil
      end
    end
  end

  context 'Adding customer with inviter' do
    describe 'Adding customer' do
      before(:each) do
        @customers_collection = customers_collection
        @customers_collection.add('B', invited_customer)
      end

      it 'customer should be unconfirmed' do
        expect(@customers_collection.get('B').confirmed).to eq false
      end

      it 'customer should has inviter' do
        expect(@customers_collection.get('B').invited_by).to be_kind_of RewardsSystem::Customer
      end
    end
  end

  describe 'Adding accepted customer without inviter' do
    it 'should has accepted customer' do
      customers_collection.add_as_accepted('A')

      expect(customers_collection.size).to eq 1
      expect(customers_collection.customers.keys).to eq ['A']
      expect(customers_collection.get('A').confirmed).to eq true
      expect(customers_collection.get('A').invited_by).to be_nil
    end
  end

  describe 'Accepted by existing customer in collection' do
    it 'should be confirmed' do
      customers_collection.add('A', customer)
      customers_collection.add_as_accepted('A')
      expect(customers_collection.get('A').confirmed).to eq true
    end
  end

  describe 'Adding recommendation to collection' do
    it 'should be in collection' do
      customers_collection.add_as_recommended('A', 'B')
      expect(customers_collection.size).to eq 2
      expect(customers_collection.get('B').invited_by.name).to eq 'A'
      expect(customers_collection.customers.keys).to eq %w[A B]
      expect(customers_collection.get('B').confirmed).to eq false
      expect(customers_collection.get('A').confirmed).to eq true
    end
  end

  describe 'Adding recommendation for recommended before' do
    it 'should not override first inviter' do
      customers_collection.add_as_recommended('A', 'B')
      customers_collection.add_as_recommended('C', 'B')
      expect(customers_collection.get('B').invited_by.name).to eq 'A'
    end
  end

  describe 'Accepted invitation from recommended one' do
    it 'should be as confirmed' do
      customers_collection.add_as_recommended('A', 'B')
      customers_collection.add_as_accepted('B')
      expect(customers_collection.get('B').confirmed).to eq true
    end
  end

  describe 'Calculating points for simple collection' do
    let(:file_data) do
      <<-INPUT_DATA
          2018-06-12 09:41 A recommends B
          2018-06-14 09:41 B accepts
      INPUT_DATA
    end

    it 'should has the right points for each customer' do
      customers_collection = RewardsSystem::FileInputParser.new(file_data).populate_customers_collection
      customers_collection.calculate_rewards

      expect(customers_collection.get('A').points).to eq 1
      expect(customers_collection.get('B').points).to eq 0
    end
  end

  describe 'Calculating points for more complicated collection' do
    let(:file_data) do
      <<-INPUT_DATA
          2018-06-12 09:41 A recommends B
          2018-06-14 09:41 B accepts
          2018-06-16 09:41 B recommends C
          2018-06-17 09:41 C accepts
          2018-06-19 09:41 C recommends D
          2018-06-23 09:41 B recommends D
          2018-06-25 09:41 D accepts
          2018-06-26 09:41 D recommends E
      INPUT_DATA
    end

    it 'should has the right points for each customer' do
      customers_collection = RewardsSystem::FileInputParser.new(file_data).populate_customers_collection
      customers_collection.calculate_rewards

      expect(customers_collection.get('A').points).to eq 1.75
      expect(customers_collection.get('B').points).to eq 1.5
      expect(customers_collection.get('C').points).to eq 1
      expect(customers_collection.get('D').points).to eq 0
    end
  end
end
