class ChangeRoleDefaultInUsers < ActiveRecord::Migration[8.0]
  def up
    # Change the default value
    change_column_default :users, :role, from: 'user', to: 'receptionist'

    # Update existing records with the old default value
    User.where(role: 'user').update_all(role: 'receptionist')
  end

  def down
    # Revert back to the original default
    change_column_default :users, :role, from: 'receptionist', to: 'user'

    # Revert the records we changed (note: this might not be perfect if some were originally 'user')
    User.where(role: 'receptionist').update_all(role: 'user')
  end
end
