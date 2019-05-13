class CreateSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribers do |t|
      t.integer :user_id
      t.integer :study_id

      t.timestamps
    end
  end
end
