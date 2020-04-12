class AddOverallToReview < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :overall, :integer
  end
end
