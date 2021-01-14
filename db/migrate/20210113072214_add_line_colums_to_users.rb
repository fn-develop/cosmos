class AddLineColumsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :line_display_name, :string, after: :line_user_id
    add_column :users, :line_image_url, :string, after: :line_display_name
    add_column :users, :line_status_message, :string, after: :line_image_url
  end
end
