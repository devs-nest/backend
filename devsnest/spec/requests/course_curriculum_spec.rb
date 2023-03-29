# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourseCurriculum, type: :request do
  context 'CourseCurriculum - request specs' do
    context 'get CourseCurriculum' do
      let(:user) { create(:user) }
      let!(:course) { create(:course, name: 'test') }
      let!(:course_curriculum) { create(:course_curriculum, course_id: course.id, course_type: 'dsa') }
      let!(:course_curriculum2) { create(:course_curriculum, course_id: course.id, course_type: 'frontend') }
      let!(:course_curriculum3) { create(:course_curriculum, course_id: course.id, course_type: 'backend') }
      let!(:question) { create(:challenge, topic: 0, question_body: 'testbody xyz', user_id: user.id, name: 'two sum test', is_active: true, score: 100, difficulty: 'medium') }
      let!(:assignment_question) { create(:assignment_question, course_curriculum_id: course_curriculum.id, question_id: question.id, question_type: 'Challenge') }
      let!(:ucs) { create(:user_challenge_score, user_id: user.id, challenge_id: question.id, passed_test_cases: 10, total_test_cases: 10) }
      let!(:question2) { create(:challenge, topic: 0, question_body: 'testbody xyz', user_id: user.id, name: 'two sum test 2', is_active: true, score: 100, difficulty: 'medium') }
      let!(:assignment_question2) { create(:assignment_question, course_curriculum_id: course_curriculum.id, question_id: question2.id, question_type: 'Challenge') }
      let!(:u_s1) { create(:algo_submission, user_id: user.id, challenge_id: question2.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }

      it 'should return unauthorized when user is not logged in' do
        get '/api/v1/course-curriculum'
        expect(response).to have_http_status(401)
      end

      it 'should return all course curriculums when user is logged in and search with a filter name' do
        sign_in(user)
        get '/api/v1/course-curriculum?filter[course_name]=test'
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data'].count).to eq(3)
      end

      it 'should return no course curriculums when course name is wrong' do
        sign_in(user)
        get '/api/v1/course-curriculum?filter[course_name]=invalid'
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data'].count).to eq(0)
      end
    end
  end
end
