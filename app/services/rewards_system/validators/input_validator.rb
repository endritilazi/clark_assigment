# frozen_string_literal: true

module RewardsSystem
  module Validators
    class InputValidator
      include ActiveModel::Model

      attr_reader :file_data

      VALID_ACTIONS = %w[recommends accepts].freeze
      ROW_PARTS_LENGTHS = [4, 5].freeze

      validates :file_data, presence: true

      validate :validate_format

      def initialize(file_data)
        @file_data = file_data.strip
        @current_row_index = nil
        @datetimes = []
        @pending_invitations = {}
        @costumers = {}
      end

      def validate_format
        @file_data.each_line.with_index do |row, index|
          row.strip!
          @current_row_index = index + 1
          validate_row(row)
          date, time, partition_one, action, partition_two = row.split
          validate_date(date, time)
          validate_action(action, partition_one, partition_two)
          validate_actions_sequence
        end
      end

      def validate_row(row)
        splitted_parts = row.split
        return if ROW_PARTS_LENGTHS.include?(splitted_parts.size)

        errors.add(:file_data, "Row #{@current_row_index} is not understandable")
        throw(:abort)
      end

      def validate_date(date, time)
        @datetimes << RewardsSystem::DataParser.parse_date_time(date, time)
      rescue ArgumentError
        errors.add(:datetime, "Date or time is not correct at row #{@current_row_index}")
        throw(:abort)
      end

      def validate_action(action, partition_one, partition_two)
        if VALID_ACTIONS.include? action
          send("validate_#{action}", partition_one, partition_two)
        else
          errors.add(:action, "The action #{action} is not allowed at row #{@current_row_index}")
          throw(:abort)
        end
      end

      def validate_accepts(*partitions)
        partition_one = partitions[0]
        if @costumers[partition_one] == 1
          errors.add(:action, "Can not accept invitation more than once at row #{@current_row_index}")
          throw(:abort)
        else
          @costumers[partition_one] = 1
          @pending_invitations[partition_one] = nil
        end
      end

      def validate_recommends(*partitions)
        partition_one, partition_two = partitions
        if partition_two == partition_one
          errors.add(:action, "Can not recommend him self at row #{@current_row_index}")
          throw(:abort)
        elsif @pending_invitations[partition_one] == 1
          errors.add(:action, "Can not recommend without accepting it first at row #{@current_row_index}")
          throw(:abort)
        end
        @pending_invitations[partition_two] = 1
      end

      def validate_actions_sequence
        return if @datetimes.size == 1

        @datetimes[0..-2].each_with_index do |date, index|
          if date > @datetimes[index + 1]
            errors.add(:datetime, 'The sequence of actions is not in order')
            throw(:abort)
          end
        end
      end
    end
  end
end
