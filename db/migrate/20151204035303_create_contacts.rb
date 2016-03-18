class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :email
      t.string :telephone
      t.string :mobile
      t.string :website
      t.string :fax
      t.string :skype
      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
