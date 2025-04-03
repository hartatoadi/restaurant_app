class RenameStatusToOrderStatusInOrders < ActiveRecord::Migration[8.0]
  def change
    rename_column :orders, :status, :order_state
  end
end
