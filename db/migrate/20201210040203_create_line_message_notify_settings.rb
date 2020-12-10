class CreateLineMessageNotifySettings < ActiveRecord::Migration[6.0]
  def change
    create_table :line_message_notify_settings do |t|
      t.integer :company_id,       null:    false
      t.boolean :notify_enabled,   default: true
      t.integer :norify_time_from, default: 0
      t.integer :norify_time_to,   default: 0
      t.integer :notify_cycle,     default: 0
      t.string  :notify_target,    defalt:  :owner

      t.timestamps
    end
  end
end
