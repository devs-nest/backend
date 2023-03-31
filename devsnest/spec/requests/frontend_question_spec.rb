# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Frontend question creation', type: :request do
  context 'frontend-questions spec' do
    context 'get frontend-questions' do
      let(:user) { create(:user) }
      let(:frontend_question1) { create(:frontend_question) }
      let(:s3_object) { double('s3_object') }
      let(:s3_bucket) { double('s3_bucket') }
      let(:s3_resource) { double(:s3_resource) }
      let(:s3) { double(:s3) }
      let(:file1) { "template_files/#{frontend_question1.id}/file1.txt" }
      let(:file2) { "template_files/#{frontend_question1.id}/file2.txt" }
      let(:file3) { "submissions/#{frontend_question1.id}/#{user.id}/file1.txt" }
      let(:file4) { "submissions/#{frontend_question1.id}/#{user.id}/file2.txt" }

      it 'should not return the frontend question when user is not logged in' do
        get "/api/v1/frontend-questions/#{frontend_question1.id}"
        expect(response).to have_http_status(401)
      end

      it 'should return the frontend question' do
        sign_in(user)
        allow($s3_resource).to receive(:bucket).and_return(s3_resource)
        allow(s3_resource).to receive(:objects).with(prefix: "template_files/#{frontend_question1.id}/").and_return([double(:object, key: file1), double(:object, key: file2)])
        allow(s3_resource).to receive(:objects).with(prefix: "submissions/#{frontend_question1.id}/#{user.id}/").and_return([double(:object, key: file3), double(:object, key: file4)])
        allow($s3).to receive(:get_object).with(bucket: 'devsnest-dev-minibootcamp', key: file1).and_return(double(:object, body: double(:body, read: 'file1---content')))
        allow($s3).to receive(:get_object).with(bucket: 'devsnest-dev-minibootcamp', key: file2).and_return(double(:object, body: double(:body, read: 'file2---content')))
        allow($s3).to receive(:get_object).with(bucket: 'devsnest-dev-minibootcamp', key: file3).and_return(double(:object, body: double(:body, read: 'file3---content')))
        allow($s3).to receive(:get_object).with(bucket: 'devsnest-dev-minibootcamp', key: file4).and_return(double(:object, body: double(:body, read: 'file4---content')))
        get "/api/v1/frontend-questions/#{frontend_question1.id}"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['id'].to_i).to eq(frontend_question1.id)
        expect(JSON.parse(response.body)['data']['attributes']['template_files']).to eq({ "file1": 'file1---content', "file2": 'file2---content' }.as_json)
        expect(JSON.parse(response.body)['data']['attributes']['last_submitted_files']).to eq({ "/file1": 'file3---content', "/file2": 'file4---content' }.as_json)
      end
    end
  end
end
