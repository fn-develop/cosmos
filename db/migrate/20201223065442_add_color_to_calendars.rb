class AddColorToCalendars < ActiveRecord::Migration[6.0]
  def change
    add_column :calendars, :color, :string, after: :title
  end
end
