require 'rails_helper'

RSpec.describe "UserChallengeScores", type: :request do
  describe "GET /user_challenge_scores" do
    it "works! (now write some real specs)" do
      get user_challenge_scores_path
      expect(response).to have_http_status(200)
    end
  end
end
