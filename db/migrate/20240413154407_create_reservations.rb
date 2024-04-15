class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.integer :reservation_external_id
      t.integer :ticket_number
      t.date :reservation_date
      t.time :reservation_time
      t.string :sales_chanel
      t.integer :prix
      t.string :type_of_product
      t.references :representation, null: false, foreign_key: true
      t.references :spectacle, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
