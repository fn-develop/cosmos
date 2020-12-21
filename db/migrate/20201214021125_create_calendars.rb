class CreateCalendars < ActiveRecord::Migration[6.0]
  def change
    create_table :calendars do |t|
      t.integer  :company_id, null:    false
      t.string   :title
      t.datetime :start
      t.datetime :end
      t.string   :allday,     default: 'false'
      t.string   :site_url
      t.string   :event_type

      t.integer  :staff_id
      t.timestamps
    end
  end
end
