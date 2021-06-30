# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Onboard, type: :model do
  context 'check to_csv method' do
    it 'checks for empty csv' do
      expect(described_class.to_csv).to eq "user_id,discord_username,discord_id,name,college,college_year,school,work_exp,known_from,dsa_skill,webd_skill\n"
    end
  end
end
