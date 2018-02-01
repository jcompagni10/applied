class AddStacksToApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :be_stack, :string
    add_column :applications, :fe_stack, :string
    add_column :applications, :other_stack, :string
  end
end
