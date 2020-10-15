class CreateStudies < ActiveRecord::Migration[5.2]
  def change
    create_table :studies do |t|
      t.string :name
      t.string :description
      t.boolean :public_subscribe
      t.boolean :public_contribute

      t.timestamps
    end
  end
end
