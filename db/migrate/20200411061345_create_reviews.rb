class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :content
      t.string :smoking
      t.string :cleanliness
      t.string :attribute
      t.string :customer
      t.references :user, foreign_key: true
      t.references :parlor, foreign_key: true

      t.timestamps
    end

    add_index :reviews, :created_at
  end
end
