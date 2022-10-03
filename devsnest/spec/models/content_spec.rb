# frozen_string_literal: true

# == Schema Information
#
# Table name: contents
#
#  id              :bigint           not null, primary key
#  data_type       :integer
#  difficulty      :integer
#  extra_link1     :string(255)
#  extra_link2     :string(255)
#  link            :string(255)
#  name            :string(255)
#  priority        :integer
#  question_type   :integer
#  reference_data  :json
#  score           :integer
#  video_questions :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_id       :string(255)
#  unique_id       :string(255)
#
# Indexes
#
#  index_contents_on_parent_id  (parent_id)
#  index_contents_on_unique_id  (unique_id)
#
require 'rails_helper'

RSpec.describe Content, type: :model do
  context 'check creation' do
    let(:content1) { create(:content, difficulty: 0) }

    it 'creates content instance' do
      expect(content1.name).to be_present
      expect(content1.link).to be_present
      expect(content1.data_type).to be_present
      expect(content1.difficulty).to be_present
    end
  end

  context 'check difficulty split' do
    before do
      create(:content, data_type: 0, difficulty: 0)
      create(:content, data_type: 0, difficulty: 1)
      create(:content, data_type: 0, difficulty: 2)
      create(:content, data_type: 0, difficulty: 0)
    end
    let(:total_ques) { Content.split_by_difficulty }

    it 'checks difficulty splits' do
      expect(total_ques.is_a?(Hash)).to eq(true)
      expect(total_ques).to have_key('easy')
      expect((total_ques)['easy']).to eq(2)
      expect(total_ques).to have_key('medium')
      expect((total_ques)['medium']).to eq(1)
      expect(total_ques).to have_key('hard')
      expect((total_ques)['hard']).to eq(1)
      expect(total_ques.values.inject { |a, b| a + b }).to eq(4)
    end
  end
end
