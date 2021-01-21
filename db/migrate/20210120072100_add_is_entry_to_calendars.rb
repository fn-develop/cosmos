class AddIsEntryToCalendars < ActiveRecord::Migration[6.0]
  def change
    add_column :calendars, :is_entry, :boolean, default: false, after: :event_type
  end
end
