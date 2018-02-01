class AddTagColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :tag, :string
  end
end
