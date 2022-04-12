class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!

  def update
    @order_detail = OrderDetail.find(params[:id])
    @order_detail.update(making_status: params[:order_detail][:making_status])
    redirect_back(fallback_location: root_path)
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:order_id, :item_id, :making_status)
  end

end
