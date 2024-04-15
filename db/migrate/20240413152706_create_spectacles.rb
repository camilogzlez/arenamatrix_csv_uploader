class CreateSpectacles < ActiveRecord::Migration[7.1]
  def change
    create_table :spectacles do |t|
      t.integer :spectacle_external_id
      t.string :spectacle_name

      t.timestamps
    end
  end
end
