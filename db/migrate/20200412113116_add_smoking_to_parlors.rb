class AddSmokingToParlors < ActiveRecord::Migration[5.2]
  def change
    remove_column  :parlors, :smoking
    add_column :parlors, :smoking, :integer, default: 0
  end
end
