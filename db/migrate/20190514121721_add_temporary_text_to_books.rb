class AddTemporaryTextToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :temporary_text, :string
  end
end
