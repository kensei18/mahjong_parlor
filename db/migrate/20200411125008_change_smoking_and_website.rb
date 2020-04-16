class ChangeSmokingAndWebsite < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :smoking
    add_column :parlors, :smoking, :integer
    add_column :parlors, :website, :string
  end
end
