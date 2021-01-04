class AddSubcodeToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :sub_code, :string, after: :code
  end
end
