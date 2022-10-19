# frozen_string_literal: true

require 'rails_helper'
RSpec.describe GroupActivityPointsUpdateWorker, type: :worker do
  context 'When group activity points update worker is called' do
    let!(:user) { create(:user) }
    let!(:server) { create(:server, name: 'Devsnest', guild_id: '123456789') }
    let!(:group) { create(:group, owner_id: user.id, server_id: server.id, name: 'Test Team', activity_point: 2) }
    it 'Should reCalculate activity points' do
      GroupActivityPointsUpdateWorker.new.perform
      group.reload
      expect(group.activity_point).to eq(0)
    end
  end
end
