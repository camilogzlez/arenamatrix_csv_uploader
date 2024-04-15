class CreateRepresentations < ActiveRecord::Migration[7.1]
  def change
    create_table :representations do |t|
      t.integer :representation_external_id
      t.string :representation_name
      t.date :representation_date
      t.time :representation_time
      t.date :representation_end_date
      t.time :representation_end_time
      t.references :spectacle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
