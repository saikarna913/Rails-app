class ChangeDefaultRoleToReceptionist < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :role, from: 'user', to: 'receptionist'

    # Update existing users with role 'user' to 'receptionist' if needed
    reversible do |direction|
      direction.up do
        User.where(role: 'user').update_all(role: 'receptionist')
      end
    end
  end
end
