class CoinLogsController < ApplicationController
  before_action :set_coin_log, only: [:show, :update, :destroy]

  # GET /coin_logs
  def index
    @coin_logs = CoinLog.all

    render json: @coin_logs
  end

  # GET /coin_logs/1
  def show
    render json: @coin_log
  end

  # POST /coin_logs
  def create
    @coin_log = CoinLog.new(coin_log_params)

    if @coin_log.save
      render json: @coin_log, status: :created, location: @coin_log
    else
      render json: @coin_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /coin_logs/1
  def update
    if @coin_log.update(coin_log_params)
      render json: @coin_log
    else
      render json: @coin_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /coin_logs/1
  def destroy
    @coin_log.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coin_log
      @coin_log = CoinLog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def coin_log_params
      params.fetch(:coin_log, {})
    end
end
