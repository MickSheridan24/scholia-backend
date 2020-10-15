class AddBodyToAnnotations < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :body, :string
  end
end
