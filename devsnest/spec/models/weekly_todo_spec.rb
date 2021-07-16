# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeeklyTodo, type: :model do
  context 'check creation' do
    let(:group) { create(:group) }
    let(:weeklytodo) { create(:weekly_todo, group_id: group.id) }

    it 'check creation week' do
      expect(weeklytodo.creation_week).to eq(Date.current.at_beginning_of_week)
    end
  end
end
