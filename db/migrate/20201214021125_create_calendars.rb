class CreateCalendars < ActiveRecord::Migration[6.0]
  def change
    create_table :calendars do |t|
      t.integer  :company_id,    null: false
      t.string   :title
      t.integer  :start_year
      t.integer  :start_month
      t.integer  :start_day
      t.integer  :start_hour
      t.integer  :start_minute
      t.integer  :end_year
      t.integer  :end_month
      t.integer  :end_day
      t.integer  :end_hour
      t.integer  :end_minute
      t.boolean  :allday, default: false
      t.string   :backgroundcolor
      t.string   :bordercolor
      t.string   :url
      t.string   :event_type

      t.integer  :staff_id, null: false
      t.timestamps
    end
  end
end
