# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeeklyTodo, type: :model do
  context 'check creation' do
    let!(:server1) { create(:server, id: 1, name: 'Devsnest', guild_id: '123456789') }
    let(:group) { create(:group, server_id: server1.id) }
    let(:weeklytodo) { create(:weekly_todo, group_id: group.id) }

    it 'check creation week' do
      expect(weeklytodo.creation_week).to eq(Date.current.at_beginning_of_week)
    end
  end
end
