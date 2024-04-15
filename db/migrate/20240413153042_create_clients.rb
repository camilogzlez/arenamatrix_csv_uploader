class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :address
      t.integer :zip_code
      t.string :country
      t.integer :age
      t.string :sex

      t.timestamps
    end
  end
end
