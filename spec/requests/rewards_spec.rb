# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rewards', type: 'request' do
  describe 'Calculate' do
    it 'returns blank error form empty file data' do
      post '/rewards/calculate'
      expected_errors = { 'file_data' => ['can\'t be blank'] }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq expected_errors
    end

    it 'returns the json with points' do
      file_data = <<-INPUT_DATA
        2018-06-12 09:41 A recommends B
        2018-06-14 09:41 B accepts
        2018-06-16 09:41 B recommends C
        2018-06-17 09:41 C accepts
        2018-06-19 09:41 C recommends D
        2018-06-23 09:41 B recommends D
        2018-06-25 09:41 D accepts
      INPUT_DATA

      expected_points = { A: 1.75, B: 1.5, C: 1 }

      post '/rewards/calculate', params: file_data, headers: {}

      expect(JSON.parse(response.body).symbolize_keys).to eq expected_points
    end
  end
end
