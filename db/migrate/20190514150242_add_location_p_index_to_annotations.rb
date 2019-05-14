class AddLocationPIndexToAnnotations < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :location_p_index, :integer
  end
end
