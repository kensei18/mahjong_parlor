class ChangeParlorsLatLng < ActiveRecord::Migration[5.2]
  def change
    remove_column :parlors, :latitude
    remove_column :parlors, :longitude
    add_column :parlors, :latitude, :decimal, precision: 10, scale: 7
    add_column :parlors, :longitude, :decimal, precision: 10, scale: 7
  end
end
