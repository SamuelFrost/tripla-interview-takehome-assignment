class PricingController < ApplicationController
  before_action :validate_params

  def index
    rate = HotelRoomPrice.find_by!(period: params[:period], hotel: params[:hotel], room: params[:room]).rate

    # ISSUE: using a single rate returned for index does not follow restful api naming conventions, consider renaming to show
    render json: { rate: }
  end

  private

  def validate_params
    # Validate required parameters
    unless params[:period].present? && params[:hotel].present? && params[:room].present?
      return render json: { error: "Missing required parameters: period, hotel, room" }, status: :bad_request
    end

    # Validate parameter values
    unless RateApi::VALID_PERIODS.include?(params[:period])
      return render json: { error: "Invalid period. Must be one of: #{RateApi::VALID_PERIODS.join(', ')}" }, status: :bad_request
    end

    unless RateApi::VALID_HOTELS.include?(params[:hotel])
      return render json: { error: "Invalid hotel. Must be one of: #{RateApi::VALID_HOTELS.join(', ')}" }, status: :bad_request
    end

    unless RateApi::VALID_ROOMS.include?(params[:room])
      return render json: { error: "Invalid room. Must be one of: #{RateApi::VALID_ROOMS.join(', ')}" }, status: :bad_request
    end
  end
end
