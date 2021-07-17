# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrum, type: :model do
  context 'check creation' do
    let(:scrum) { create(:scrum) }

    it 'check creation week' do
      expect(scrum.creation_date).to eq(Date.current)
    end
  end
end
