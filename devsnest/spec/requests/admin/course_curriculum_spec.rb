# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourseCurriculum, type: :request do
  let(:user) { create(:user) }
  let!(:course) { create(:course, name: 'test') }
  let!(:course_curriculum) { create(:course_curriculum, course_id: course.id, course_type: 'dsa') }
  let!(:course_curriculum2) { create(:course_curriculum, course_id: course.id, course_type: 'frontend') }
  let!(:course_curriculum3) { create(:course_curriculum, course_id: course.id, course_type: 'backend') }
  before :each do
    sign_in(user)
  end

  context 'Course - Permission Checks' do
    it 'If User is not Admin' do
      get '/api/v1/admin/course-curriculum'

      expect(response.status).to eq(401)
    end

    it 'If User is Admin' do
      user.update(user_type: 1)
      get '/api/v1/admin/course-curriculum?filter[course_name]=test'

      expect(response.status).to eq(200)
    end
  end
end
