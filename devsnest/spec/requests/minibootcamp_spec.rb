# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Minibootcamp', type: :request do
  context 'Challenge - request specs' do
    context 'get Content' do
      let(:user) { create(:user) }
      let!(:minibootcamp_question) { create(:minibootcamp, unique_id: 'HTML', current_lesson_number: 0) }
      let!(:minibootcamp_question) { create(:minibootcamp, parent_id: 'HTML', unique_id: 'Q1', current_lesson_number: 1) }
      let!(:minibootcamp_question) { create(:minibootcamp, parent_id: 'HTML', unique_id: 'Q2', current_lesson_number: 2) }
      let!(:minibootcamp_question) { create(:minibootcamp, parent_id: 'HTML', unique_id: 'Q3', current_lesson_number: 3) }

      it 'should return Challenges when exists' do
        get '/api/v1/minibootcamp'
        expect(response).to have_http_status(200)
      end

      it 'return the side menu items' do
        get '/api/v1/minibootcamp/menu?parent_id=HTML'
        expect(response).to have_http_status(200)
      end
    end
  end
end
