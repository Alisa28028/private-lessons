class ChangeEventInstancePriceToPriceCents < ActiveRecord::Migration[7.1]
  def change
    remove_column :event_instances, :price, :decimal
    add_monetize :event_instances, :price, currency: { present: false }
  end
end
