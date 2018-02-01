class AddSourceToApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :source, :string
  end
end
