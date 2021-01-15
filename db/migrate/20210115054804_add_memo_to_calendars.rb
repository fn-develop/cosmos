class AddMemoToCalendars < ActiveRecord::Migration[6.0]
  def change
    add_column :calendars, :memo, :text, after: :event_type
  end
end
