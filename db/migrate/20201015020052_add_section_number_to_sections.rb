class AddSectionNumberToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :sections, :section_number, :integer
    add_index :sections, :section_number
  end
end
