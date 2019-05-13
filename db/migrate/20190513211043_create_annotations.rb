class CreateAnnotations < ActiveRecord::Migration[5.2]
  def change
    create_table :annotations do |t|
      t.integer :book_id
      t.integer :user_id
      t.integer :study_id
      t.string :title
      t.integer :bodylocation_p_index
      t.integer :location_char_index
      t.string :color
      t.boolean :public

      t.timestamps
    end
  end
end
