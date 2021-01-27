class CreateCalendarJoinedUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :calendar_joined_users do |t|
      t.integer :calendar_id, null: false
      t.integer :user_id,     null: false
      t.boolean :is_join,     default: false
      t.string  :comment

      t.timestamps
    end
  end
end
