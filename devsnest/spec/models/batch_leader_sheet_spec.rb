# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BatchLeaderSheet, type: :model do
  context 'check creation' do
    let(:batchleadersheet) { create(:batch_leader_sheet) }

    it 'check creation week' do
      expect(batchleadersheet.creation_week).to eq(Date.current.at_beginning_of_week)
    end
  end
end
