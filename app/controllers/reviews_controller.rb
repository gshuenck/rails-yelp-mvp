class ReviewsController < ApplicationController
  before_action :set_restaurant
  before_action :set_review, only: [:destroy]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.restaurant = @restaurant
    if @review.save
      redirect_to restaurant_path(@restaurant), notice: 'Review was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Rails.logger.info "Review found: #{@review.inspect}"
    @review.destroy!
    redirect_to restaurant_path(@review.restaurant), status: :see_other, notice: 'Review was successfully destroyed.'
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Restaurant not found with ID: #{params[:restaurant_id]}"
    redirect_to root_path, alert: 'Restaurant not found.'
  end

  def set_review
    @review = Review.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Review not found with ID: #{params[:id]}"
    redirect_to @restaurant, alert: 'Review not found.'
  end

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
