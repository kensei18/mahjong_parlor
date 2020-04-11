class ChangeReviewsAttributeColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :attribute
    add_column :reviews, :service, :integer
  end
end
