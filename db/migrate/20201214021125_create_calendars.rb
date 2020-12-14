class CreateCalendars < ActiveRecord::Migration[6.0]
  def change
    create_table :calendars do |t|
      t.integer  :company_id,    null: false
      t.string   :year,          null: false
      t.string   :month,         null: false
      t.string   :day,           null: false
      t.integer  :ymd_num,       null: false
      t.integer  :type,          null: false
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.integer  :staff_id,      null: false

      t.timestamps
    end
  end
end
