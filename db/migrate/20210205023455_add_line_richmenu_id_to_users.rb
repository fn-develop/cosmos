class AddLineRichmenuIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :line_richmenu_id, :string, after: :line_status_message
  end
end
