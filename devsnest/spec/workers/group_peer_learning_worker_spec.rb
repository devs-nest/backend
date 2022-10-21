# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!
RSpec.describe GroupPeerLearningWorker, type: :worker do
  context 'When group peer Learning worker get called' do
    let!(:user) { create(:user) }
    let!(:user1) { create(:user) }
    let!(:course) { create(:course) }
    let!(:server) { create(:server, name: 'Devsnest', guild_id: '123456789') }
    let!(:group) { create(:group, owner_id: user1.id, server_id: server.id, name: 'Test1 Team', scrum_start_time: DateTime.now + 10.minutes) }
    it 'Should add worker for Report Weekly Scrum' do
      expect do
        GroupPeerLearningWorker.perform_async('weekly')
      end.to change(GroupPeerLearningWorker.jobs, :size).by(Group.count)
      GroupPeerLearningWorker.new.perform('weekly')
    end
    it 'Should add worker for Attendance' do
      expect do
        GroupPeerLearningWorker.perform_async('daily')
      end.to change(GroupPeerLearningWorker.jobs, :size).by(Group.count)
      GroupPeerLearningWorker.new.perform('daily')
    end
    it 'Should add worker for Class Start' do
      expect do
        GroupPeerLearningWorker.perform_async('class_start')
      end.to change(GroupPeerLearningWorker.jobs, :size).by(Group.count)
      GroupPeerLearningWorker.new.perform('class_start')
    end
    it 'Should add worker for Ping Scrum Time' do
      expect do
        GroupPeerLearningWorker.perform_async('scrum_start')
      end.to change(GroupPeerLearningWorker.jobs, :size).by(Group.count)
      GroupPeerLearningWorker.new.perform('scrum_start')
    end
  end
end
