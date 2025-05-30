class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false

      t.timestamps
    end
    add_index :contacts, :email, unique: true
  end
end
