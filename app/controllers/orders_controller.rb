class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.includes(:customer)
                .by_order_state(params[:state])
                .order(placed_at: :desc)
                .page(params[:page])
                .per(10)
  end
end
