class AddOauthToUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :email
      t.integer :uid, null: false
      t.string :provider, null: false
    end
  end
end
