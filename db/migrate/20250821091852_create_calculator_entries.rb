class CreateCalculatorEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :calculator_entries do |t|
      t.integer :lessons
      t.integer :attendees
      t.integer :price
      t.integer :commission
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
