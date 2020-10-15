class RemoveTypeFromSections < ActiveRecord::Migration[5.2]
  def change
    remove_column :sections, :type, :string
  end
end
