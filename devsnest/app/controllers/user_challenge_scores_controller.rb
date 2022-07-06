class UserChallengeScoresController < ApplicationController
  before_action :set_user_challenge_score, only: [:show, :update, :destroy]

  # GET /user_challenge_scores
  def index
    @user_challenge_scores = UserChallengeScore.all

    render json: @user_challenge_scores
  end

  # GET /user_challenge_scores/1
  def show
    render json: @user_challenge_score
  end

  # POST /user_challenge_scores
  def create
    @user_challenge_score = UserChallengeScore.new(user_challenge_score_params)

    if @user_challenge_score.save
      render json: @user_challenge_score, status: :created, location: @user_challenge_score
    else
      render json: @user_challenge_score.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_challenge_scores/1
  def update
    if @user_challenge_score.update(user_challenge_score_params)
      render json: @user_challenge_score
    else
      render json: @user_challenge_score.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_challenge_scores/1
  def destroy
    @user_challenge_score.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_challenge_score
      @user_challenge_score = UserChallengeScore.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_challenge_score_params
      params.fetch(:user_challenge_score, {})
    end
end
