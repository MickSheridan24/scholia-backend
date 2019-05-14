class RemoveBodylocationPIndexFromAnnotations < ActiveRecord::Migration[5.2]
  def change
    remove_column :annotations, :bodylocation_p_index, :integer
  end
end
