
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
    context "onboarding" do
        let(:user) { create(:user, discord_active: true) }
        let(:controller) { Api::V1::UsersController }
        before :each do   
            #@mock_controller.stub(:current_user).and_return(User.first)
            sign_in(user)
        end

        let(:parameters) do
            {
              "data": {
                "type": "onboards",
                "attributes": {
                  "discord_username": "KayDee#8576",
                  "discord_id": "1234567890",
                  "name": "KayDee",
                  "college_name": "TestGrp",
                  "grad_year": 2,
                  "work_exp": "2mnth",
                  "known_from": "Friend",
                  "dsa_skill": 4,
                  "webd_skill": 3,
                  "is_discord_form_filled": true
                             }
                     }
              }
          end
        

        it "basic first put call" do
          put "/api/v1/users/onboard", params: parameters.to_json, headers: HEADERS
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq("Form filled")
        end

        it "basic put call when user already filled the form" do
            user.update(is_discord_form_filled: true)
            put "/api/v1/users/onboard", params: parameters.to_json, headers: HEADERS
            expect(response.status).to eq(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq("Discord form already filled")
        end

        it "when user's discord is not connected" do
            user.update(discord_active: false)
            put "/api/v1/users/onboard", params: parameters.to_json, headers: HEADERS
            expect(response.status).to eq(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq("Discord isn't connected")
        end

        it "when user is already in group" do
            group = create(:group)
            create(:group_member, user_id: user.id, group_id: group.id)
            put "/api/v1/users/onboard", params: parameters.to_json, headers: HEADERS
            expect(response.status).to eq(400)
            expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq("User already in a group")
        end
    end

end
    