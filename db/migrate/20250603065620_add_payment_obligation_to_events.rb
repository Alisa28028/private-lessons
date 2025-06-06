class AddPaymentObligationToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :payment_obligation_on_booking, :boolean
  end
end
