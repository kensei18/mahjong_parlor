class CreateParlors < ActiveRecord::Migration[5.2]
  def change
    create_table :parlors do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :parlors, :address, unique: true
    add_index :parlors, [:latitude, :longitude], unique: true
  end
end
