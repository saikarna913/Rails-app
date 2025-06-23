class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string, default: 'user', null: false

    reversible do |direction|
      direction.up do
        execute <<-SQL
          ALTER TABLE users
          ADD CONSTRAINT check_valid_role
          CHECK (role IN ('user', 'admin', 'receptionist', 'doctor'))
        SQL
      end
      direction.down do
        execute <<-SQL
          ALTER TABLE users
          DROP CONSTRAINT IF EXISTS check_valid_role
        SQL
      end
    end

    add_index :users, :role
  end
end
