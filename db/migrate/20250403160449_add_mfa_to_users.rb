class AddMfaToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :mfa_secret, :string
    add_column :users, :mfa_verified, :boolean, default: false
  end
end
