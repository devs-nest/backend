# frozen_string_literal: true

# == Schema Information
#
# Table name: weekly_todos
#
#  id                    :bigint           not null, primary key
#  batch_leader_rating   :integer
#  comments              :text(65535)
#  creation_week         :date
#  extra_activity        :text(65535)
#  group_activity_rating :integer
#  moral_status          :integer
#  obstacles             :text(65535)
#  sheet_filled          :boolean
#  todo_list             :json
#  group_id              :integer
#
# Indexes
#
#  index_weekly_todos_on_group_id_and_creation_week  (group_id,creation_week) UNIQUE
#
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
