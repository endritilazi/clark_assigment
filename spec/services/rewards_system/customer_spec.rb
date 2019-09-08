# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsSystem::Customer do
  let(:customer) { described_class.new('A', nil, false) }

  describe 'initialize' do
    it { expect(customer.name).to eq 'A' }
    it { expect(customer.invited_by).to be_nil }
    it { expect(customer.confirmed).to eq false }
    it { expect(customer.points).to eq 0 }
  end

  describe 'adding point to customer' do
    it 'should has one point' do
      customer.add_points(1)
      expect(customer.points).to eq 1
    end
  end

  describe 'confirming invitation' do
    it 'should be customer confirmed' do
      customer.confirm_invitation
      expect(customer.confirmed).to eq true
    end
  end

  describe 'creating customer with inviter' do
    it 'should has inviter' do
      invited_customer = described_class.new('B', customer, false)
      expect(invited_customer.invited_by).to equal customer
      expect(invited_customer.confirmed).to eq false
    end
  end
end
