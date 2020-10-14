class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
      t.text :html
      t.text :plain
      t.integer :book_id
      t.string :type

      t.timestamps
    end
  end
end
