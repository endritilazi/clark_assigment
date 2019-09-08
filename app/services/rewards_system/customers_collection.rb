# frozen_string_literal: true

module RewardsSystem
  class CustomersCollection
    attr_accessor :customers

    def initialize
      @customers = {}
    end

    def add_as_accepted(customer_name)
      customer = get(customer_name)
      if customer.nil?
        add(customer_name, Customer.new(customer_name, nil, true))
      else
        customer.confirm_invitation
      end
    end

    def add_as_recommended(inviter_name, invited_name)
      inviter = get(inviter_name)
      if inviter.nil?
        inviter = Customer.new(inviter_name, nil, true)
        add(inviter_name, inviter)
      end
      add(invited_name, Customer.new(invited_name, inviter)) if get(invited_name).nil?
    end

    def calculate_rewards
      customers.values.map(&:add_points_to_inviter)
    end

    def get(key)
      customers[key]
    end

    def add(key, customer)
      customers[key] = customer
    end

    def each(&block)
      customers.values.each { |c| block.call(c) }
    end

    def map(&block)
      result = []
      customers.each do |customer|
        result << block.call(customer)
      end
      result
    end

    def size
      customers.size
    end
  end
end
