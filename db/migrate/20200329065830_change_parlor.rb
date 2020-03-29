class ChangeParlor < ActiveRecord::Migration[5.2]
  def change
    remove_index :parlors, column: :address
    remove_index :parlors, column: [:latitude, :longitude]
    add_index :parlors, [:name, :address], unique: true
  end
end
