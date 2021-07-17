# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrum, type: :request do
  context 'Scrum - request specs' do
    context 'get Scrums' do 
      let(:group) { create(:group) }
      let(:user) { create(:user) }
      let(:scrum) { create(:scrum) }

      before :each do
        sign_in(user)
      end

      it 'should '

    end
  end
end
