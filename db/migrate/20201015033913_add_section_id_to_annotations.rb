class AddSectionIdToAnnotations < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :section_id, :integer
  end
end
