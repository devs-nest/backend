# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Content, type: :model do

  context "check creation" do
  let(:content1) { create(:content, difficulty: 0) }
  
    it 'creates content instance' do
      expect(content1.name).to be_present
      expect(content1.link).to be_present
      expect(content1.data_type).to be_present
      expect(content1.difficulty).to be_present
    end
  end

  

  context "check difficulty split" do
    
    before{ 
      create(:content, data_type: 0, difficulty: 0)
      create(:content, data_type: 0, difficulty: 1)
      create(:content, data_type: 0, difficulty: 2)
      create(:content, data_type: 0)
    }
    let(:total_ques) { Content.split_by_difficulty }
    
    it 'checks difficulty splits' do
      
      expect(total_ques.is_a?(Hash)).to eq(true)
      expect(total_ques).to have_key("easy")
      expect(total_ques).to have_key("medium")
      expect(total_ques).to have_key("hard")
      expect(total_ques.values.inject {|a,b| a+b}).to eq(4)

    end
  end
end
