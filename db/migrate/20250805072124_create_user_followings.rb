class CreateUserFollowings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_followings do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :following, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :user_followings, [:follower_id, :following_id], unique: true
  end
end
