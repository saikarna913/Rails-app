class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :medical_record_number, limit: 10
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
