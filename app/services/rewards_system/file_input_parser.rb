# frozen_string_literal: true

module RewardsSystem
  class FileInputParser
    attr_reader :customers_collection

    def initialize(file_data)
      @file_data = file_data
      @customers_collection = CustomersCollection.new
    end

    def populate_customers_collection
      @file_data.each_line do |row|
        row.strip!
        partition_one, action, partition_two = row.split[2..-1]
        if action == 'accepts'
          customers_collection.add_as_accepted(partition_one)
        else
          customers_collection.add_as_recommended(partition_one, partition_two)
        end
      end
      customers_collection
    end
  end
end
