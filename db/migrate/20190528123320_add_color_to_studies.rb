class AddColorToStudies < ActiveRecord::Migration[5.2]
  def change
    add_column :studies, :color, :string
  end
end
