class CreateApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :applications do |t|
      t.string :email
      t.string :company
      t.string :position
      t.string :contact_name
      t.string :url
      t.boolean :sent

      t.timestamps
    end
  end
end
