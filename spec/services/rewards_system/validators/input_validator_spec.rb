# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsSystem::Validators::InputValidator do
  let(:input_validator) { described_class.new(input_data) }

  describe 'Validation of file' do
    context 'Validation should success' do
      let(:input_data) do
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

      it { expect(input_validator.valid?).to eq true }
    end

    context 'Validation should fail' do
      describe 'When row is not understandable' do
        let(:input_data) do
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends B accepts
          INPUT_DATA
        end

        it do
          expect(input_validator).to_not be_valid
          expect(input_validator.errors[:file_data].count).to eq 1
        end
      end

      describe 'When date format is not right' do
        let(:input_data) do
          <<-INPUT_DATA
          2018-062-12 09:41 A recommends B
          INPUT_DATA
        end

        it do
          expect(input_validator).to_not be_valid
          expect(input_validator.errors[:datetime].count).to eq 1
        end
      end

      describe 'When actions is not known' do
        let(:input_data) do
          <<-INPUT_DATA
          2018-06-12 09:41 A invites B
          INPUT_DATA
        end

        it do
          expect(input_validator).to_not be_valid
          expect(input_validator.errors[:action].count).to eq 1
        end
      end

      describe 'When invitation is accepted two times' do
        let(:input_data) do
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends B
          2018-06-14 09:41 B accepts
          2018-07-14 09:41 B accepts
          INPUT_DATA
        end

        it do
          expect(input_validator).to_not be_valid
          expect(input_validator.errors[:action].count).to eq 1
        end
      end

      describe 'When recommends him self' do
        let(:input_data) do
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends A
          INPUT_DATA
        end

        it do
          expect(input_validator).to_not be_valid
          expect(input_validator.errors[:action].count).to eq 1
        end
      end

      describe 'When recommends without accepting it' do
        let(:input_data) do
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends B
          2018-06-16 09:41 B recommends C
          2018-06-17 09:41 C accepts
          INPUT_DATA
        end

        it do
          expect(input_validator).to_not be_valid
          expect(input_validator.errors[:action].count).to eq 1
        end
      end

      describe 'When date sequence is not correct' do
        let(:input_data) do
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends B
          2018-06-16 09:41 B accepts
          2018-06-14 09:41 B recommends C
          2018-06-17 09:41 B recommends D
          INPUT_DATA
        end

        it do
          expect(input_validator).to_not be_valid
          expect(input_validator.errors[:datetime].count).to eq 1
        end
      end
    end
  end
end
