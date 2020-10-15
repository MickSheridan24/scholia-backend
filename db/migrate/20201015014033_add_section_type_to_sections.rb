class AddSectionTypeToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :sections, :section_type, :string
  end
end
