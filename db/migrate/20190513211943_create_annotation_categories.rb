class CreateAnnotationCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :annotation_categories do |t|
      t.integer :annotation_id
      t.integer :category_id

      t.timestamps
    end
  end
end
